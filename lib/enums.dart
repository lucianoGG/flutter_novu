import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.kebab)
enum ProviderId {
  slack,
  discord,
  msteams,
  mattermost,
  ryver,
  zulip,
  grafanaOnCall,
  getstream,
  rocketChat,
  whatsappBusiness,
  fcm,
  apns,
  expo,
  oneSignal,
  pushpad,
  pushWebhook,
  pusherBeams
}

enum ApiMethod { post, get, put, patch, delete }

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum WorkflowStepFilterType {
  boolean,
  text,
  date,
  number,
  statement,
  list,
  multiList,
  group
}

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum FieldLogicalOperator { and, or }

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum FieldOperator {
  larger,
  smaller,
  largerEqual,
  smallerEqual,
  equal,
  notEqual,
  allIn,
  anyIn,
  notIn,
  between,
  notBetween,
  like,
  notLike,
  @JsonValue('IN')
  iin,
}

enum WorkflowStepFilterChildrenOn { subscriber, payload }

enum WorkflowTriggerType { event }

@JsonEnum(fieldRename: FieldRename.snake)
enum ChannelType { inApp, email, sms, chat, push }

enum SubscriberPreferenceLevel { global, template }

enum WebSocketEvent {
  received('notification_received'),
  unread('unread_count_changed'),
  unseen('unseen_count_changed');

  final String value;

  const WebSocketEvent(this.value);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum ActorType {
  none,
  user,
  systemIcon,
  systemCustom,
}

enum ChannelCTAType {
  redirect,
}

enum MessageActionStatus { pending, done }

enum ButtonType { primary, secondary }

enum NotificationStatus {
  sent,
  error,
  warning;
}

enum WorkflowType {
  regular,
  echo,
  bridge,
}

enum TriggerType { event }

@JsonEnum(fieldRename: FieldRename.pascal)
enum TemplateVariableType { string, array, boolean }

enum TriggerContextTypeEnum {
  tenant,
  actor,
}

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum StepContentIssueEnum {
  missingVariableInPayload,
  illegalVariableInControlValue,
  missingValue,
  minValue,
  invalidUrl,
  tierLimitExceeded,
}

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum StepIssueEnum { stepIdExists, missingRequiredValue }

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum BuilderFieldType {
  boolean,
  text,
  date,
  number,
  statement,
  list,
  multiList,
  group
}

enum FilterPartTypeEnum {
  payload,
  subscriber,
  webhook,
  isOnline,
  isOnlineInLast,
  previousStep,
  tenant,
}

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum TimeOperator {
  days,
  hours,
  minutes,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum StepType { inApp, email, sms, chat, push, digest, trigger, delay, custom }

enum MessageTemplateContentType { editor, customHtml }

enum EmailBlockType {
  button,
  text,
}

enum MarkNotificationAs { read, unread, seen, unseen, archive, unarchive }

enum MarkAllNotificationAs {
  read('read'),
  archive('archive'),
  readArchive('read-archive');

  final String value;

  const MarkAllNotificationAs(this.value);
}

enum PreferenceOverrideSource { subscriber, template, workflowOverride }

enum CardActionPosition { bottom, title, menu }

enum IconPosition { left, right, top }

enum ListItemType {
  choice,
  color,
  danger,
  navigation,
  text,
  switching,
}
