import 'package:gaubeVaha/networking/networking.dart';
import 'package:gaubeVaha/store/store_global.dart';

class SendDocumentBuild {
  SendDocumentBuild({
    this.documentId,
    this.documentType,
    this.documentTypes,
    this.documentEmails,
  });

  final String? documentId;
  final String? documentType;
  final List? documentTypes;
  final List? documentEmails;

  sendDocumentByEmail() async {
    NetworkHelper networkHelper = NetworkHelper(
      module: Global.mainModule,
      action: 'send-document-by-email',
      data: {
        'document_id': documentId,
        'document_type': documentType,
        'document_types': documentTypes,
        'document_emails': documentEmails,
      },
    );

    var resData = await networkHelper.postData();

    return resData;
    /* TODO: if (resData['data'].isNotEmpty) {
      return resData['data'];
    } else {
      return {};
    } */
  }
}
