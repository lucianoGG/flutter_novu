// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentIssue _$ContentIssueFromJson(Map<String, dynamic> json) => ContentIssue(
      issueType: $enumDecode(_$StepContentIssueEnumEnumMap, json['issueType']),
      variableName: json['variableName'] as String?,
      message: json['message'] as String,
    );

Map<String, dynamic> _$ContentIssueToJson(ContentIssue instance) =>
    <String, dynamic>{
      'issueType': _$StepContentIssueEnumEnumMap[instance.issueType]!,
      'variableName': instance.variableName,
      'message': instance.message,
    };

const _$StepContentIssueEnumEnumMap = {
  StepContentIssueEnum.missingVariableInPayload: 'MISSING_VARIABLE_IN_PAYLOAD',
  StepContentIssueEnum.illegalVariableInControlValue:
      'ILLEGAL_VARIABLE_IN_CONTROL_VALUE',
  StepContentIssueEnum.missingValue: 'MISSING_VALUE',
  StepContentIssueEnum.minValue: 'MIN_VALUE',
  StepContentIssueEnum.invalidUrl: 'INVALID_URL',
  StepContentIssueEnum.tierLimitExceeded: 'TIER_LIMIT_EXCEEDED',
};

StepIssue _$StepIssueFromJson(Map<String, dynamic> json) => StepIssue(
      issueType: $enumDecode(_$StepIssueEnumEnumMap, json['issueType']),
      variableName: json['variableName'] as String?,
      message: json['message'] as String,
    );

Map<String, dynamic> _$StepIssueToJson(StepIssue instance) => <String, dynamic>{
      'issueType': _$StepIssueEnumEnumMap[instance.issueType]!,
      'variableName': instance.variableName,
      'message': instance.message,
    };

const _$StepIssueEnumEnumMap = {
  StepIssueEnum.stepIdExists: 'STEP_ID_EXISTS',
  StepIssueEnum.missingRequiredValue: 'MISSING_REQUIRED_VALUE',
};

StepIssues _$StepIssuesFromJson(Map<String, dynamic> json) => StepIssues(
      body: (json['body'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, StepIssue.fromJson(e as Map<String, dynamic>)),
      ),
      controls: (json['controls'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => ContentIssue.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
    );

Map<String, dynamic> _$StepIssuesToJson(StepIssues instance) =>
    <String, dynamic>{
      'body': instance.body,
      'controls': instance.controls,
    };

FilterParts _$FilterPartsFromJson(Map<String, dynamic> json) => FilterParts(
      field: json['field'] as String,
      value: json['value'],
      operator: $enumDecode(_$FieldOperatorEnumMap, json['operator']),
      on: $enumDecode(_$FilterPartTypeEnumEnumMap, json['on']),
      webhookUrl: json['webhookUrl'] as String?,
      timeOperator:
          $enumDecodeNullable(_$TimeOperatorEnumMap, json['timeOperator']),
      step: json['step'] as String,
    );

Map<String, dynamic> _$FilterPartsToJson(FilterParts instance) =>
    <String, dynamic>{
      'field': instance.field,
      'value': instance.value,
      'operator': _$FieldOperatorEnumMap[instance.operator]!,
      'on': _$FilterPartTypeEnumEnumMap[instance.on]!,
      'webhookUrl': instance.webhookUrl,
      'timeOperator': _$TimeOperatorEnumMap[instance.timeOperator],
      'step': instance.step,
    };

const _$FieldOperatorEnumMap = {
  FieldOperator.larger: 'LARGER',
  FieldOperator.smaller: 'SMALLER',
  FieldOperator.largerEqual: 'LARGER_EQUAL',
  FieldOperator.smallerEqual: 'SMALLER_EQUAL',
  FieldOperator.equal: 'EQUAL',
  FieldOperator.notEqual: 'NOT_EQUAL',
  FieldOperator.allIn: 'ALL_IN',
  FieldOperator.anyIn: 'ANY_IN',
  FieldOperator.notIn: 'NOT_IN',
  FieldOperator.between: 'BETWEEN',
  FieldOperator.notBetween: 'NOT_BETWEEN',
  FieldOperator.like: 'LIKE',
  FieldOperator.notLike: 'NOT_LIKE',
  FieldOperator.iin: 'IN',
};

const _$FilterPartTypeEnumEnumMap = {
  FilterPartTypeEnum.payload: 'payload',
  FilterPartTypeEnum.subscriber: 'subscriber',
  FilterPartTypeEnum.webhook: 'webhook',
  FilterPartTypeEnum.isOnline: 'isOnline',
  FilterPartTypeEnum.isOnlineInLast: 'isOnlineInLast',
  FilterPartTypeEnum.previousStep: 'previousStep',
  FilterPartTypeEnum.tenant: 'tenant',
};

const _$TimeOperatorEnumMap = {
  TimeOperator.days: 'DAYS',
  TimeOperator.hours: 'HOURS',
  TimeOperator.minutes: 'MINUTES',
};

MessageFilter _$MessageFilterFromJson(Map<String, dynamic> json) =>
    MessageFilter(
      isNegated: json['isNegated'] as bool?,
      type: $enumDecodeNullable(_$BuilderFieldTypeEnumMap, json['type']),
      value: $enumDecode(_$FieldLogicalOperatorEnumMap, json['value']),
      children: (json['children'] as List<dynamic>)
          .map((e) => FilterParts.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MessageFilterToJson(MessageFilter instance) =>
    <String, dynamic>{
      'isNegated': instance.isNegated,
      'type': _$BuilderFieldTypeEnumMap[instance.type],
      'value': _$FieldLogicalOperatorEnumMap[instance.value]!,
      'children': instance.children,
    };

const _$BuilderFieldTypeEnumMap = {
  BuilderFieldType.boolean: 'BOOLEAN',
  BuilderFieldType.text: 'TEXT',
  BuilderFieldType.date: 'DATE',
  BuilderFieldType.number: 'NUMBER',
  BuilderFieldType.statement: 'STATEMENT',
  BuilderFieldType.list: 'LIST',
  BuilderFieldType.multiList: 'MULTI_LIST',
  BuilderFieldType.group: 'GROUP',
};

const _$FieldLogicalOperatorEnumMap = {
  FieldLogicalOperator.and: 'AND',
  FieldLogicalOperator.or: 'OR',
};

StepVariant _$StepVariantFromJson(Map<String, dynamic> json) => StepVariant(
      id: json['_id'] as String,
      uuid: json['uuid'] as String?,
      stepId: json['stepId'] as String?,
      issues: json['issues'] == null
          ? null
          : StepIssues.fromJson(json['issues'] as Map<String, dynamic>),
      name: json['name'] as String?,
      filters: (json['filters'] as List<dynamic>?)
          ?.map((e) => MessageFilter.fromJson(e as Map<String, dynamic>))
          .toList(),
      templateId: json['_templateId'] as String?,
      parentId: json['_parentId'] as String?,
      template: json['template'] == null
          ? null
          : MessageTemplate.fromJson(json['template'] as Map<String, dynamic>),
      active: json['active'] as bool?,
      shouldStopOnFail: json['shouldStopOnFail'] as bool?,
      replyCallback: json['replyCallback'] == null
          ? null
          : ReplyCallback.fromJson(
              json['replyCallback'] as Map<String, dynamic>),
      controlVariables: json['controlVariables'] as Map<String, dynamic>?,
      bridgeUrl: json['bridgeUrl'] as String?,
    );

Map<String, dynamic> _$StepVariantToJson(StepVariant instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'uuid': instance.uuid,
      'stepId': instance.stepId,
      'issues': instance.issues,
      'name': instance.name,
      'filters': instance.filters,
      '_templateId': instance.templateId,
      '_parentId': instance.parentId,
      'template': instance.template,
      'active': instance.active,
      'shouldStopOnFail': instance.shouldStopOnFail,
      'replyCallback': instance.replyCallback,
      'controlVariables': instance.controlVariables,
      'bridgeUrl': instance.bridgeUrl,
    };

NotificationTriggerVariable _$NotificationTriggerVariableFromJson(
        Map<String, dynamic> json) =>
    NotificationTriggerVariable(
      name: json['name'] as String,
      value: json['value'],
      type: $enumDecodeNullable(_$TemplateVariableTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$NotificationTriggerVariableToJson(
        NotificationTriggerVariable instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'type': _$TemplateVariableTypeEnumMap[instance.type],
    };

const _$TemplateVariableTypeEnumMap = {
  TemplateVariableType.string: 'String',
  TemplateVariableType.array: 'Array',
  TemplateVariableType.boolean: 'Boolean',
};

TriggerReservedVariable _$TriggerReservedVariableFromJson(
        Map<String, dynamic> json) =>
    TriggerReservedVariable(
      type: $enumDecode(_$TriggerContextTypeEnumEnumMap, json['type']),
      variables: (json['variables'] as List<dynamic>)
          .map((e) =>
              NotificationTriggerVariable.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TriggerReservedVariableToJson(
        TriggerReservedVariable instance) =>
    <String, dynamic>{
      'type': _$TriggerContextTypeEnumEnumMap[instance.type]!,
      'variables': instance.variables,
    };

const _$TriggerContextTypeEnumEnumMap = {
  TriggerContextTypeEnum.tenant: 'tenant',
  TriggerContextTypeEnum.actor: 'actor',
};

NotificationTrigger _$NotificationTriggerFromJson(Map<String, dynamic> json) =>
    NotificationTrigger(
      type: $enumDecode(_$TriggerTypeEnumMap, json['type']),
      identifier: json['identifier'] as String,
      variables: (json['variables'] as List<dynamic>)
          .map((e) =>
              NotificationTriggerVariable.fromJson(e as Map<String, dynamic>))
          .toList(),
      subscriberVariables: (json['subscriberVariables'] as List<dynamic>?)
          ?.map((e) =>
              NotificationTriggerVariable.fromJson(e as Map<String, dynamic>))
          .toList(),
      reservedVariables: (json['reservedVariables'] as List<dynamic>?)
          ?.map((e) =>
              TriggerReservedVariable.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotificationTriggerToJson(
        NotificationTrigger instance) =>
    <String, dynamic>{
      'type': _$TriggerTypeEnumMap[instance.type]!,
      'identifier': instance.identifier,
      'variables': instance.variables,
      'subscriberVariables': instance.subscriberVariables,
      'reservedVariables': instance.reservedVariables,
    };

const _$TriggerTypeEnumMap = {
  TriggerType.event: 'event',
};

NotificationStep _$NotificationStepFromJson(Map<String, dynamic> json) =>
    NotificationStep(
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => StepVariant.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: $enumDecodeNullable(_$TriggerTypeEnumMap, json['type']),
      identifier: json['identifier'] as String?,
    );

Map<String, dynamic> _$NotificationStepToJson(NotificationStep instance) =>
    <String, dynamic>{
      'variants': instance.variants,
      'type': _$TriggerTypeEnumMap[instance.type],
      'identifier': instance.identifier,
    };

NotificationTemplate _$NotificationTemplateFromJson(
        Map<String, dynamic> json) =>
    NotificationTemplate(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      notificationGroupId: json['_notificationGroupId'] as String,
      parentId: json['_organizationId'] as String?,
      environmentId: json['_environmentId'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      draft: json['draft'] as bool?,
      active: json['active'] as bool,
      critical: json['critical'] as bool,
      preferenceSettings: PreferenceChannel.fromJson(
          json['preferenceSettings'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => NotificationStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      triggers: (json['triggers'] as List<dynamic>)
          .map((e) => NotificationTrigger.fromJson(e as Map<String, dynamic>))
          .toList(),
      isBlueprint: json['isBlueprint'] as bool?,
      blueprintId: json['blueprintId'] as String?,
      type: $enumDecodeNullable(_$WorkflowTypeEnumMap, json['type']),
      payloadSchema: json['payloadSchema'] as Map<String, dynamic>?,
      rawData: json['rawData'] as Map<String, dynamic>?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NotificationTemplateToJson(
        NotificationTemplate instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      '_notificationGroupId': instance.notificationGroupId,
      '_organizationId': instance.parentId,
      '_environmentId': instance.environmentId,
      'tags': instance.tags,
      'draft': instance.draft,
      'active': instance.active,
      'critical': instance.critical,
      'preferenceSettings': instance.preferenceSettings,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'steps': instance.steps,
      'triggers': instance.triggers,
      'isBlueprint': instance.isBlueprint,
      'blueprintId': instance.blueprintId,
      'type': _$WorkflowTypeEnumMap[instance.type],
      'payloadSchema': instance.payloadSchema,
      'rawData': instance.rawData,
      'data': instance.data,
    };

const _$WorkflowTypeEnumMap = {
  WorkflowType.regular: 'REGULAR',
  WorkflowType.echo: 'ECHO',
  WorkflowType.bridge: 'BRIDGE',
};
