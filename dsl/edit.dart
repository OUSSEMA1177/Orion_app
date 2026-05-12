library;

import 'dart:io';

import 'package:flutterflow_ai/flutterflow_ai.dart';
import 'package:flutterflow_ai/src/client/project_error.dart';
import 'package:flutterflow_ai/src/helpers/api_helpers.dart' show findApiEndpoint;
import 'package:flutterflow_ai/src/helpers/variable_helpers.dart'
    show varFromTextFieldValue;

Future<void> main(List<String> args) async {
  final options = _parseCliOptions(args);
  try {
    await flutterFlowAI(
      buildStarterEditFlow,
      apiKey: options.apiKey,
      baseUrl: options.baseUrl,
      projectName: options.projectName,
      projectId: options.projectId,
      findOrCreate: options.findOrCreate,
      allowNewProject: options.allowNewProject,
      dryRun: options.dryRun,
      commitMessage: options.commitMessage,
      validationFilter: _validationFilterAllowPushWithKnownProjectIssues,
    );
  } catch (error) {
    stderr.writeln('Error: ${formatFlutterFlowAIError(error)}');
    exit(1);
  }
}

final class _CliOptions {
  const _CliOptions({
    this.apiKey,
    this.baseUrl,
    this.projectName,
    this.projectId,
    this.findOrCreate = false,
    this.allowNewProject = false,
    this.dryRun = false,
    this.commitMessage,
  });

  final String? apiKey;
  final String? baseUrl;
  final String? projectName;
  final String? projectId;
  final bool findOrCreate;
  final bool allowNewProject;
  final bool dryRun;
  final String? commitMessage;
}

_CliOptions _parseCliOptions(List<String> args) {
  String? apiKey;
  String? baseUrl;
  String? projectName;
  String? projectId;
  String? commitMessage;
  var findOrCreate = false;
  var allowNewProject = false;
  var dryRun = false;

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    switch (arg) {
      case '--help':
      case '-h':
        _printUsage();
        exit(0);
      case '--api-key':
        apiKey = _requireValue(args, ++i, '--api-key');
      case '--base-url':
        baseUrl = _requireValue(args, ++i, '--base-url');
      case '--project-name':
        projectName = _requireValue(args, ++i, '--project-name');
      case '--project-id':
        projectId = _requireValue(args, ++i, '--project-id');
      case '--commit-message':
        commitMessage = _requireValue(args, ++i, '--commit-message');
      case '--find-or-create':
        findOrCreate = true;
      case '--allow-new-project':
        allowNewProject = true;
      case '--dry-run':
        dryRun = true;
      default:
        stderr.writeln('Unknown option: $arg');
        _printUsage();
        exit(64);
    }
  }

  return _CliOptions(
    apiKey: apiKey,
    baseUrl: baseUrl,
    projectName: projectName,
    projectId: projectId,
    findOrCreate: findOrCreate,
    allowNewProject: allowNewProject,
    dryRun: dryRun,
    commitMessage: commitMessage,
  );
}

String _requireValue(List<String> args, int index, String flag) {
  if (index >= args.length) {
    stderr.writeln('Missing value for $flag.');
    _printUsage();
    exit(64);
  }
  return args[index];
}

void _printUsage() {
  stdout.writeln('''
Run the starter FlutterFlow AI edit flow.

Usage:
  dart run dsl/edit.dart [options]

Options:
  --api-key <key>           FlutterFlow API key. Defaults to FF_API_KEY.
  --base-url <url>          Override the FlutterFlow API base URL.
  --project-name <name>     Create a new project with this name.
  --project-id <id>         Push into an existing project by ID.
  --find-or-create          Retry by reusing a same-name project before creating.
  --allow-new-project       Bypass the workspace binding guard and create a different project.
  --commit-message <text>   Commit message for the push.
  --dry-run                 Compile and validate without pushing.
  --help, -h                Show this help.
''');
}

/// Drops a small set of remote-project validator **errors** that are unrelated
/// to this edit flow (e.g. `Button_y4ggrfum` conditional wiring). Return `true`
/// to keep an error, `false` to suppress it.
bool _validationFilterAllowPushWithKnownProjectIssues(ProjectError e) {
  if (!e.isError) {
    return true;
  }
  final m = e.message;
  if (m.contains('Conditional execution for action is improperly set')) {
    return false;
  }
  if (m.contains('Conditional action must have a True or False action')) {
    return false;
  }
  if (m.contains('Action not defined')) {
    return false;
  }
  return true;
}

void buildStarterEditFlow(App app) {
  // Fixes FlutterFlow-built `Badwordsticket` + `isMessageApproved` on
  // `ticket_conversation` (message text was never passed to the API).
  app.raw(_patchTicketConversationBadwordModeration);

  // Freeimage.host returns `image.url`, not `result.image.url` (see
  // https://freeimage.host/api). Wrong JSONPath leaves `file_path` empty in
  // Firestore so only the sender sees a local preview; receivers get blank images.
  // Also completes `sub_ticket` creates after image upload when `ticket_id` /
  // `sender_id` / etc. were missing.
  app.raw(_patchTicketConversationImageUploadFirestore);

  // Admin drawer DSL is disabled for pushes: it triggers remote validation
  // failures ("Action not defined") on this project. Re-enable locally when
  // those routes/actions are aligned with FlutterFlow.
  /*
  app.editPage('ADMIN_PAGE', (page) {
    page.ensureReplaced(
      page.findByType('Drawer'),
      Drawer(
        name: 'AdminNavDrawer',
        elevation: 16,
        width: 260,
        child: Container(
          name: 'AdminNavDrawerRoot',
          color: Colors.hex(0xFF0B0F19),
          child: Column(
            name: 'AdminNavDrawerColumn',
            crossAxis: CrossAxis.stretch,
            children: [
              Container(
                name: 'AdminNavDrawerHeader',
                height: 84,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                child: Row(
                  spacing: 8,
                  children: [
                    Icon(
                      'diamond_outlined',
                      size: 28,
                      color: Colors.hex(0xFF00A878),
                    ),
                    Text(
                      'RION',
                      style: Styles.titleMedium,
                      color: Colors.hex(0xFF00A878),
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                Column(
                  scrollable: true,
                  children: [
                    ListTile(
                      leadingIcon: 'dashboard',
                      title: 'Dashboard',
                      onTap: [const DrawerControl.close()],
                    ),
                    ListTile(
                      leadingIcon: 'people_outline',
                      title: 'Users',
                      onTap: [
                        const DrawerControl.close(),
                        Snackbar('Users page not implemented yet'),
                      ],
                    ),
                    ListTile(
                      leadingIcon: 'request_page',
                      title: 'Freelancer Requests',
                      onTap: [
                        const DrawerControl.close(),
                        Snackbar('Freelancer Requests not implemented yet'),
                      ],
                    ),
                    ListTile(
                      leadingIcon: 'category_outlined',
                      title: 'Categories',
                      onTap: [
                        const DrawerControl.close(),
                        Navigate('WORKERCATEGORY_PAGE'),
                      ],
                    ),
                    ListTile(
                      leadingIcon: 'shopping_bag_outlined',
                      title: 'Service Requests',
                      onTap: [
                        const DrawerControl.close(),
                        Navigate('service_admin'),
                      ],
                    ),
                    ListTile(
                      leadingIcon: 'local_offer_outlined',
                      title: 'Offers',
                      onTap: [
                        const DrawerControl.close(),
                        Navigate('Admin_Offers'),
                      ],
                    ),
                    ListTile(
                      leadingIcon: 'article_outlined',
                      title: 'Contracts',
                      onTap: [
                        const DrawerControl.close(),
                        Navigate('ContractListPage'),
                      ],
                    ),
                    ListTile(
                      leadingIcon: 'timeline',
                      title: 'Milestones',
                      onTap: [
                        const DrawerControl.close(),
                        Navigate('MilestoneListPage'),
                      ],
                    ),
                    Divider(),
                    ListTile(
                      leadingIcon: 'support_agent_outlined',
                      title: 'Tickets',
                      onTap: [
                        const DrawerControl.close(),
                        Navigate('ticket_dashboard'),
                      ],
                    ),
                    ListTile(
                      leadingIcon: 'smart_toy_outlined',
                      title: 'AI Ops Dashboard',
                      onTap: [
                        const DrawerControl.close(),
                        Snackbar('AI Ops Dashboard not implemented yet'),
                      ],
                    ),
                    ListTile(
                      leadingIcon: 'view_kanban_outlined',
                      title: 'Ticket Board',
                      onTap: [
                        const DrawerControl.close(),
                        Navigate('ticket_homepage'),
                      ],
                    ),
                    ListTile(
                      leadingIcon: 'timeline_outlined',
                      title: 'Ticket Timeline',
                      onTap: [
                        const DrawerControl.close(),
                        Navigate('ticket_stats'),
                      ],
                    ),
                    ListTile(
                      leadingIcon: 'label_outline',
                      title: 'Ticket Categories',
                      onTap: [
                        const DrawerControl.close(),
                        Navigate('ADMIN_CAT_TICKET'),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                name: 'AdminNavDrawerFooter',
                padding: EdgeInsets.all(12),
                child: Row(
                  spacing: 12,
                  children: [
                    Container(
                      name: 'AdminNavDrawerAvatar',
                      width: 42,
                      height: 42,
                      color: Colors.hex(0xFF161B22),
                      borderRadius: 10,
                      alignment: Alignment.center,
                      child: Icon(
                        'person_outline',
                        color: Colors.hex(0xFFF0F6FC),
                      ),
                    ),
                    Expanded(
                      Column(
                        crossAxis: CrossAxis.start,
                        spacing: 4,
                        children: [
                          Text(
                            'System Account',
                            style: Styles.bodyMedium,
                            color: Colors.hex(0xFFF0F6FC),
                          ),
                          Container(
                            name: 'AdminNavRoleChip',
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            color: Colors.hex(0xFF00A878),
                            borderRadius: 6,
                            child: Text(
                              'ADMIN',
                              style: Styles.bodySmall,
                              color: Colors.hex(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      'logout',
                      size: 20,
                      color: Colors.hex(0xFFF0F6FC),
                      borderRadius: 8,
                      name: 'AdminNavSignOut',
                      onTap: [
                        const DrawerControl.close(),
                        Snackbar('Signed out'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  });
  */
}

/// Patches the FlutterFlow UI-built ticket chat moderation (Groq
/// `Badwordsticket` API + `isMessageApproved` custom function).
void _patchTicketConversationBadwordModeration(FFProject project) {
  updateCustomFunction(
    project,
    name: 'isMessageApproved',
    code: r'''
try {
  dynamic map = apiResponse;
  if (apiResponse is String) {
    final s = apiResponse.trim();
    if (s.isEmpty) {
      return false;
    }
    map = json.decode(s);
  }
  if (map is! Map) {
    return false;
  }
  final choices = map['choices'];
  if (choices is! List || choices.isEmpty) {
    return false;
  }
  final first = choices.first;
  if (first is! Map) {
    return false;
  }
  final message = first['message'];
  if (message is! Map) {
    return false;
  }
  final raw = message['content']?.toString() ?? '';
  final upper = raw.trim().toUpperCase();
  // Letters only so we never treat "NOT APPROVED" as containing "APPROVED".
  final lettersOnly = upper.replaceAll(RegExp('[^A-Z]'), '');
  if (lettersOnly == 'APPROVED') {
    return true;
  }
  return false;
} catch (e) {
  return false;
}
''',
  );

  final endpoint = _findBadwordsticketEndpoint(project);
  final messageTextDef = endpoint == null
      ? null
      : _messageTextVariableIdentifier(endpoint);

  _bindBadwordsticketMessageTextOnPage(
    project,
    pageName: 'ticket_conversation',
    textFieldKey: 'TextField_9929fys0',
    messageTextVariableIdentifier: messageTextDef,
  );
}

FFApiEndpoint? _findBadwordsticketEndpoint(FFProject project) {
  final standalone = findApiEndpoint(project, name: 'Badwordsticket');
  if (standalone != null) {
    return standalone;
  }
  for (final g in project.backend.apiConfig.apiGroups) {
    final inGroup = findApiEndpoint(
      project,
      name: 'Badwordsticket',
      groupName: g.identifier.name,
    );
    if (inGroup != null) {
      return inGroup;
    }
  }
  return null;
}

FFIdentifier? _messageTextVariableIdentifier(FFApiEndpoint endpoint) {
  for (final fv in endpoint.variables) {
    final n = fv.identifier.name.toLowerCase();
    final k = fv.identifier.key.toLowerCase();
    if (n == 'messagetext' || k == 'messagetext') {
      return fv.identifier;
    }
  }
  return null;
}

/// Binds `messageText` on every `Badwordsticket` API call under the page
/// (not only a specific IconButton key), so codegen emits `messageText` args.
void _bindBadwordsticketMessageTextOnPage(
  FFProject project, {
  required String pageName,
  required String textFieldKey,
  FFIdentifier? messageTextVariableIdentifier,
}) {
  FFWidgetClass? wc;
  for (final pageKey in project.pageKeys) {
    final candidate = project.widgetClasses[pageKey];
    if (candidate != null && candidate.name == pageName) {
      wc = candidate;
      break;
    }
  }
  if (wc == null) {
    return;
  }
  _scanWidgetTreeForBadwordApi(
    wc.node,
    textFieldKey,
    messageTextVariableIdentifier,
  );
}

void _scanWidgetTreeForBadwordApi(
  FFNode node,
  String textFieldKey,
  FFIdentifier? messageTextVariableIdentifier,
) {
  for (final ta in node.triggerActions) {
    if (!ta.hasTrigger()) {
      continue;
    }
    if (ta.trigger.triggerType != FFActionTriggerType.ON_TAP) {
      continue;
    }
    if (!ta.hasRootAction()) {
      continue;
    }
    _visitActionNodes(ta.rootAction, (actionNode) {
      _patchBadwordsticketMessageTextVariable(
        actionNode,
        textFieldKey,
        messageTextVariableIdentifier,
      );
    });
  }
  for (final child in node.children) {
    _scanWidgetTreeForBadwordApi(
      child,
      textFieldKey,
      messageTextVariableIdentifier,
    );
  }
}

void _visitActionNodes(
  FFActionNode? node,
  void Function(FFActionNode node) visit,
) {
  if (node == null) {
    return;
  }
  visit(node);
  if (node.hasConditionActions()) {
    final ca = node.conditionActions;
    if (ca.hasFalseAction()) {
      _visitActionNodes(ca.falseAction, visit);
    }
    for (final t in ca.trueActions) {
      if (t.hasTrueAction()) {
        _visitActionNodes(t.trueAction, visit);
      }
    }
  }
  if (node.hasParallelActions()) {
    for (final branch in node.parallelActions.actions) {
      _visitActionNodes(branch, visit);
    }
  }
  if (node.hasFollowUpAction()) {
    _visitActionNodes(node.followUpAction, visit);
  }
}

void _patchBadwordsticketMessageTextVariable(
  FFActionNode node,
  String textFieldKey,
  FFIdentifier? messageTextVariableIdentifier,
) {
  if (!node.hasAction() || !node.action.hasDatabase()) {
    return;
  }
  final db = node.action.database;
  if (db.whichAction() != FFDatabaseAction_Action.apiCall) {
    return;
  }
  final call = db.apiCall;
  if (!call.hasEndpointIdentifier()) {
    return;
  }
  if (call.endpointIdentifier.name.toLowerCase() != 'badwordsticket') {
    return;
  }
  var patchedExisting = false;
  for (final v in call.variables) {
    if (!v.hasVariableIdentifier()) {
      continue;
    }
    final paramName = v.variableIdentifier.name.toLowerCase();
    final paramKey = v.variableIdentifier.key.toLowerCase();
    if (paramName != 'messagetext' && paramKey != 'messagetext') {
      continue;
    }
    v.clearValue();
    v.variable = varFromTextFieldValue(textFieldKey);
    patchedExisting = true;
  }
  if (!patchedExisting && messageTextVariableIdentifier != null) {
    call.variables.add(
      FFApiCallValue(
        variableIdentifier: messageTextVariableIdentifier.deepCopy(),
        variable: varFromTextFieldValue(textFieldKey),
      ),
    );
  }
}

/// Patches ticket chat image upload: correct Freeimage.host JSON path and
/// merge missing `sub_ticket` fields on image-only Firestore creates.
void _patchTicketConversationImageUploadFirestore(FFProject project) {
  _replaceFreeimageResultImageJsonPath(project);
  _mergeIncompleteSubTicketCreatesOnTicketConversation(project);
}

/// Freeimage.host API v1 uses `image.url`, not `result.image.url`
/// (https://freeimage.host/api).
void _replaceFreeimageResultImageJsonPath(FFProject project) {
  final root = project.toProto3Json();
  if (root is! Map) {
    return;
  }
  final map = Map<String, dynamic>.from(root);
  // Official API shape: top-level `image.url` (not nested under `result`).
  const replacements = <(String, String)>[
    (r'$.result.image.url', r'$.image.url'),
    (r'$.result.image.display_url', r'$.image.url'),
  ];
  for (final (wrong, right) in replacements) {
    _replaceSubstringInProto3Json(map, wrong, right);
  }
  project
    ..clear()
    ..mergeFromProto3Json(map);
}

void _replaceSubstringInProto3Json(
  dynamic node,
  String from,
  String to,
) {
  if (node is Map) {
    for (final key in node.keys.toList()) {
      final value = node[key];
      if (value is String) {
        if (value.contains(from)) {
          node[key] = value.replaceAll(from, to);
        }
      } else {
        _replaceSubstringInProto3Json(value, from, to);
      }
    }
  } else if (node is List) {
    for (var i = 0; i < node.length; i++) {
      final value = node[i];
      if (value is String) {
        if (value.contains(from)) {
          node[i] = value.replaceAll(from, to);
        }
      } else {
        _replaceSubstringInProto3Json(value, from, to);
      }
    }
  }
}

void _mergeIncompleteSubTicketCreatesOnTicketConversation(FFProject project) {
  final page = findPage(project, name: 'ticket_conversation');
  if (page == null) {
    return;
  }
  FFFirestoreCreate? reference;
  final incomplete = <FFFirestoreCreate>[];
  _scanWidgetTreeForSubTicketCreates(page.node, (create) {
    if (_subTicketCreateHasTicketId(create)) {
      reference ??= create;
    } else if (_subTicketCreateMissingTicketIdWithFilePath(create)) {
      incomplete.add(create);
    }
  });
  if (reference == null || incomplete.isEmpty) {
    return;
  }
  final ref = reference!;
  if (!ref.hasWrite()) {
    return;
  }
  final refWrite = ref.write;
  for (final inc in incomplete) {
    if (!inc.hasWrite()) {
      continue;
    }
    _mergeMissingSubTicketWriteFields(inc.write, refWrite);
  }
}

void _scanWidgetTreeForSubTicketCreates(
  FFNode node,
  void Function(FFFirestoreCreate create) visit,
) {
  for (final ta in node.triggerActions) {
    if (!ta.hasTrigger()) {
      continue;
    }
    if (!ta.hasRootAction()) {
      continue;
    }
    _visitActionNodes(ta.rootAction, (actionNode) {
      if (!actionNode.hasAction() || !actionNode.action.hasDatabase()) {
        return;
      }
      final db = actionNode.action.database;
      if (db.whichAction() != FFDatabaseAction_Action.createDocument) {
        return;
      }
      final create = db.createDocument;
      if (!_isSubTicketFirestoreCreate(create)) {
        return;
      }
      visit(create);
    });
  }
  for (final child in node.children) {
    _scanWidgetTreeForSubTicketCreates(child, visit);
  }
}

bool _isSubTicketFirestoreCreate(FFFirestoreCreate create) {
  if (!create.hasCollectionIdentifier()) {
    return false;
  }
  final n = create.collectionIdentifier.name.toLowerCase();
  return n == 'sub_ticket' || n.contains('subticket');
}

bool _subTicketCreateHasTicketId(FFFirestoreCreate create) {
  return create.hasWrite() && create.write.updates.containsKey('ticket_id');
}

bool _subTicketCreateMissingTicketIdWithFilePath(FFFirestoreCreate create) {
  return create.hasWrite() &&
      !create.write.updates.containsKey('ticket_id') &&
      create.write.updates.containsKey('file_path');
}

void _mergeMissingSubTicketWriteFields(
  FFDatabaseWrite target,
  FFDatabaseWrite source,
) {
  const keys = ['ticket_id', 'sender_id', 'message', 'is_read'];
  for (final k in keys) {
    if (target.updates.containsKey(k)) {
      continue;
    }
    if (!source.updates.containsKey(k)) {
      continue;
    }
    target.updates[k] = source.updates[k]!.deepCopy();
  }
}
