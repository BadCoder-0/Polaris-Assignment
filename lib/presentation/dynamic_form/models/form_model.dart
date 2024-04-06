class MetaInfo {
  final String label;
  final List<String>? options;
  final String mandatory;
  final String? componentInputType;

  MetaInfo({
    required this.label,
    this.options,
    required this.mandatory,
    this.componentInputType,
  });

  factory MetaInfo.fromJson(Map<String, dynamic> json) {
    return MetaInfo(
      label: json['label'],
      options: json['options'] != null ? List<String>.from(json['options'] ?? []) : null,
      mandatory: json['mandatory'],
      componentInputType: json['component_input_type'],
    );
  }
}

class Field {
  final MetaInfo metaInfo;
  final String componentType;

  Field({
    required this.metaInfo,
    required this.componentType,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      metaInfo: MetaInfo.fromJson(json['meta_info']),
      componentType: json['component_type'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Field &&
        this.metaInfo.label == other.metaInfo.label &&
        this.metaInfo.mandatory == other.metaInfo.mandatory &&
        this.metaInfo.options.toString() == other.metaInfo.options.toString() &&
        this.componentType == other.componentType;
  }

  @override
  int get hashCode {
    return metaInfo.label.hashCode ^
    metaInfo.mandatory.hashCode ^
    metaInfo.options.hashCode ^
    componentType.hashCode;
  }
}

class FormData {
  final String formName;
  final List<Field> fields;

  FormData({
    required this.formName,
    required this.fields,
  });

  factory FormData.fromJson(Map<String, dynamic> json) {
    // Convert fields to a set to remove duplicates based on meta information
    Set<Field> uniqueFields = json['fields'].map<Field>((fieldJson) => Field.fromJson(fieldJson)).toSet();

    return FormData(
      formName: json['form_name'],
      fields: uniqueFields.toList(), // Convert back to list
    );
  }
}