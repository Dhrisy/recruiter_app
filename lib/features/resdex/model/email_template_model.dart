class EmailTemplateModel {
  final String? templateName;
  final String? subject;
  final String? body;
  final int? jobId;
  final int? id;
  final String? createdOn;
  final String? email;

  EmailTemplateModel({
    this.body,
    this.id,
    this.jobId,
    this.subject,
    this.templateName,
    this.createdOn,
    this.email,
  });


  factory EmailTemplateModel.fromJson(Map<String, dynamic> json){
    return EmailTemplateModel(
      body: json["body"] ?? "N/A",
      subject: json["subject"] ?? "N/A",
      jobId: json["job"],
      templateName: json["name"] ?? "N/A",
      createdOn: json["created_on"] ?? "",
      email: json["email"] ?? "N/A",
      id: json["id"] ?? "N/A"
    );
  }
}