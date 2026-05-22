import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../core/constants/app_theme.dart';

class CvPreviewScreen extends StatelessWidget {
  final String cvUrl;

  const CvPreviewScreen({super.key, required this.cvUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('CV Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            tooltip: 'Download',
            onPressed: () {/* trigger download */},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: cvUrl.isEmpty
          ? const Center(
              child: Text(
                'No CV URL provided.',
                style: TextStyle(color: Colors.white54),
              ),
            )
          : SfPdfViewer.network(
              cvUrl,
              onDocumentLoadFailed: (details) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to load PDF: ${details.description}'),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
            ),
    );
  }
}
