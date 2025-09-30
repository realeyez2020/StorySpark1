import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/ai_client.dart';

class StoryPage {
  final int pageNumber;
  final String text;
  final String imagePrompt;
  final String? generatedImageUrl;
  String? userUploadedImagePath;

  StoryPage({
    required this.pageNumber,
    required this.text,
    required this.imagePrompt,
    this.generatedImageUrl,
    this.userUploadedImagePath,
  });
}

class StoryPreviewScreen extends StatefulWidget {
  final String storyTitle;
  final String genre;
  final String style;
  final List<StoryPage> pages;
  final String? bookId;

  const StoryPreviewScreen({
    Key? key,
    required this.storyTitle,
    required this.genre,
    required this.style,
    required this.pages,
    this.bookId,
  }) : super(key: key);

  @override
  _StoryPreviewScreenState createState() => _StoryPreviewScreenState();
}

class _StoryPreviewScreenState extends State<StoryPreviewScreen> {
  PageController pageController = PageController();
  int currentPageIndex = 0;
  late final AiClient aiClient;
  String selectedLayout = 'full-bleed'; // Default to full-page illustrations // top, bottom, overlay
  final TextEditingController _promptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Toggle this for local development
  final bool useLocalBackend = false; // Set to true for local dev, false for production
  aiClient = AiClient(useLocalBackend 
    ? 'http://localhost:3001/api' 
    : 'https://storyspark1-production.up.railway.app/api');
    // Auto-populate prompt with first page's imagePrompt
    if (widget.pages.isNotEmpty) {
      _promptController.text = widget.pages[0].imagePrompt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      body: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Page Navigation
          _buildPageNavigation(),
          
          // Main Content
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: widget.pages.length,
              onPageChanged: (index) {
                setState(() {
                  currentPageIndex = index;
                  // Auto-populate prompt with current page's imagePrompt
                  _promptController.text = widget.pages[index].imagePrompt;
                });
              },
              itemBuilder: (context, index) {
                return _buildStoryPage(widget.pages[index]);
              },
            ),
          ),
          
          // Bottom Actions
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        border: Border(
          bottom: BorderSide(color: Color(0xFF2D2D4A), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF252542),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF3D3D5C)),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.storyTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.genre,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.style,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Page ${currentPageIndex + 1} of ${widget.pages.length}',
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: currentPageIndex > 0 ? () {
                  pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } : null,
                icon: const Icon(Icons.chevron_left, color: Colors.white),
              ),
              IconButton(
                onPressed: currentPageIndex < widget.pages.length - 1 ? () {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } : null,
                icon: const Icon(Icons.chevron_right, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoryPage(StoryPage page) {
    final textLines = page.text.split('. ');
    final upperText = textLines.isNotEmpty ? textLines[0] + '.' : '';
    final lowerText = textLines.length > 1 ? textLines.sublist(1).join('. ') : '';
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          // Left side - Print Layout Preview (bigger)
          Expanded(
            flex: 3, // Bigger container
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2D2D4A), width: 1),
              ),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '${page.pageNumber}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Page Layout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButton<String>(
                              value: selectedLayout,
                              dropdownColor: const Color(0xFF252542),
                              style: const TextStyle(color: Colors.white),
                              items: const [
                                DropdownMenuItem(value: 'top', child: Text('Text Top, Image Bottom')),
                                DropdownMenuItem(value: 'bottom', child: Text('Image Top, Text Bottom')),
                                DropdownMenuItem(value: 'overlay', child: Text('Text Overlay on Image')),
                                DropdownMenuItem(value: 'full-bleed', child: Text('Full-Page Illustration 📖')),
                                DropdownMenuItem(value: 'magazine', child: Text('Magazine Layout 📰')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedLayout = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Page Content in Print Format
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _buildPageContent(page, upperText, lowerText),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _editText(page),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF374151),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit Text'),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 24),
          
          // Right side - Image Section (smaller)
          Expanded(
            flex: 2, // Smaller container
            child: Column(
              children: [
                // Image Prompt
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF2D2D4A), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('🎨', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          const Text(
                            'Image Prompt',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Editable prompt field
                      TextField(
                        controller: _promptController,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Simple children\'s book illustration: ${page.text.length > 50 ? page.text.substring(0, 50) + '...' : page.text}',
                          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                          filled: true,
                          fillColor: const Color(0xFF252542),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF3D3D5C)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF3D3D5C)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF6366F1)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _generateImage(page),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6366F1),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              icon: const Icon(Icons.auto_fix_high, size: 14),
                              label: const Text('Generate', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => _regenerateImage(page),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B5CF6),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            icon: const Icon(Icons.refresh, size: 14),
                            label: const Text('Regenerate', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Image Preview & Upload
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF2D2D4A), width: 1),
                    ),
                    child: Column(
                      children: [
                        // Image Display Area
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF252542),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFF3D3D5C), width: 2, style: BorderStyle.solid),
                            ),
                            child: page.generatedImageUrl != null || page.userUploadedImagePath != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.memory(
                                    base64Decode(page.userUploadedImagePath?.split(',').last ?? ''),
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                    height: double.infinity,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.image_outlined, size: 50, color: Color(0xFF6B7280)),
                                        SizedBox(height: 8),
                                        Text('No image yet', style: TextStyle(color: Color(0xFF6B7280))),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        
                        // Upload Controls
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xFF2D2D4A), width: 1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _uploadImage(page),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF059669),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  icon: const Icon(Icons.upload, size: 16),
                                  label: const Text('Upload Image'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _drawImage(page),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF7C3AED),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  icon: const Icon(Icons.brush, size: 16),
                                  label: const Text('Draw'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageDisplay(StoryPage page) {
    if (page.userUploadedImagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          page.userUploadedImagePath!,
          fit: BoxFit.contain,
        ),
      );
    } else if (page.generatedImageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          page.generatedImageUrl!,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder('Failed to load image');
          },
        ),
      );
    } else {
      return _buildPlaceholder('No image yet');
    }
  }

  Widget _buildPlaceholder(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.image_outlined,
            size: 48,
            color: Color(0xFF6B7280),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        border: Border(
          top: BorderSide(color: Color(0xFF2D2D4A), width: 1),
        ),
      ),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: _saveStory,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.save),
            label: const Text('Save Story'),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: _publishStory,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.publish),
            label: const Text('Publish'),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: _addNewPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Page'),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _previewBook,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.preview),
            label: const Text('Preview Book'),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(StoryPage page, String upperText, String lowerText) {
    final fullText = page.text;
    
    switch (selectedLayout) {
      case 'full-bleed':
        return _buildFullPageLayout(page, fullText);
      case 'magazine':
        return _buildMagazineLayout(page, fullText);
      case 'overlay':
        return _buildOverlayLayout(page, fullText);
      case 'bottom':
        return _buildImageTopLayout(page, upperText, lowerText);
      case 'top':
      default:
        return _buildTextTopLayout(page, upperText, lowerText);
    }
  }

  Widget _buildFullPageLayout(StoryPage page, String text) {
    return Stack(
      children: [
        // Full-page image
        Positioned.fill(
          child: page.generatedImageUrl != null || page.userUploadedImagePath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(page.userUploadedImagePath?.split(',').last ?? ''),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFF3F4F6),
                        child: const Center(
                          child: Icon(Icons.image_outlined, size: 50, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  color: const Color(0xFFF3F4F6),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined, size: 50, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Full-page illustration will appear here', 
                             style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
        ),
        // Text overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
                shadows: [
                  Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMagazineLayout(StoryPage page, String text) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: page.generatedImageUrl != null || page.userUploadedImagePath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(page.userUploadedImagePath?.split(',').last ?? ''),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: const Color(0xFFF3F4F6));
                    },
                  ),
                )
              : Container(color: const Color(0xFFF3F4F6)),
        ),
        // Text in a white box (magazine style)
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              text,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlayLayout(StoryPage page, String text) {
    return Stack(
      children: [
        // Full image
        Positioned.fill(
          child: page.generatedImageUrl != null || page.userUploadedImagePath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(page.userUploadedImagePath?.split(',').last ?? ''),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: const Color(0xFFF3F4F6));
                    },
                  ),
                )
              : Container(color: const Color(0xFFF3F4F6)),
        ),
        // Centered text with background
        Center(
          child: Container(
            margin: const EdgeInsets.all(40),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageTopLayout(StoryPage page, String upperText, String lowerText) {
    return Column(
      children: [
        // Image Area (top)
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: _buildImageWidget(page),
          ),
        ),
        // Text Area (bottom)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Text(
            upperText + lowerText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextTopLayout(StoryPage page, String upperText, String lowerText) {
    return Column(
      children: [
        // Text Area (top)
        if (upperText.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Text(
              upperText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        // Image Area (middle)
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: _buildImageWidget(page),
          ),
        ),
        // Text Area (bottom)
        if (lowerText.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Text(
              lowerText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageWidget(StoryPage page) {
    return page.generatedImageUrl != null || page.userUploadedImagePath != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              base64Decode(page.userUploadedImagePath?.split(',').last ?? ''),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                );
              },
            ),
          )
        : const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.image_outlined, size: 50, color: Colors.grey),
                SizedBox(height: 8),
                Text('No image yet', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
  }

  void _editText(StoryPage page) {
    // TODO: Implement text editing dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Edit Text', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: 400,
          child: TextField(
            controller: TextEditingController(text: page.text),
            maxLines: 8,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Edit story text...',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _generateImage(StoryPage page) async {
    final prompt = _promptController.text.isNotEmpty 
        ? _promptController.text 
        : 'Simple children\'s book illustration: ${page.text}';
        
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🎨 Generating image...')),
    );
    
    try {
      print('🔍 Debug: bookId = ${widget.bookId}');
      final imageBytes = await aiClient.generatePageImage(
        page: page.pageNumber,
        scene: prompt,
        characters: [{'name': 'child', 'type': 'character'}],
        userStyle: widget.style,
        genreLabel: widget.genre,
        bookId: widget.bookId,
        artBible: {
          'book_meta': {
            'style': widget.style,
            'palette': ['purple', 'gold', 'emerald', 'silver', 'rose'],
            'lighting': 'warm natural lighting',
            'camera_height': 'child-eye level',
          },
          'character_bible': {
            'Alex': {
              'appearance': '8-year-old child with short brown hair, bright curious eyes',
              'clothing': 'purple hoodie and blue jeans - NEVER changes outfit',
              'body_type': 'average height for 8-year-old, friendly face',
              'STRICT_RULE': 'Alex must look IDENTICAL in every single page - same face, same hair, same clothes, same proportions'
            }
          },
          'style_bible': {
            'art_consistency': 'LOCKED: same illustration style, lighting, and color palette throughout entire book',
            'forbidden_changes': ['no costume changes', 'no hair changes', 'no age changes', 'no art style variations']
          }
        },
      );
      
      final imageB64 = base64Encode(imageBytes);
      
      setState(() {
        page.userUploadedImagePath = 'data:image/png;base64,$imageB64';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✨ Image generated!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Image generation failed: $error')),
      );
    }
  }

  void _regenerateImage(StoryPage page) async {
    _generateImage(page); // Use same logic but with current prompt
  }

  void _uploadImage(StoryPage page) {
    // TODO: Implement image upload
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('📁 Upload image functionality coming soon!')),
    );
  }

  void _drawImage(StoryPage page) {
    // TODO: Implement drawing interface
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🎨 Drawing interface coming soon!')),
    );
  }

  void _saveStory() {
    try {
      final storyData = {
        'title': widget.storyTitle,
        'genre': widget.genre,
        'style': widget.style,
        'pages': widget.pages.map((page) => {
          'pageNumber': page.pageNumber,
          'text': page.text,
          'imagePrompt': page.imagePrompt,
          'generatedImageUrl': page.generatedImageUrl,
          'userUploadedImagePath': page.userUploadedImagePath,
        }).toList(),
        'savedAt': DateTime.now().toIso8601String(),
      };
      
      print('Story saved: ${jsonEncode(storyData)}');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('💾 Story saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Save failed: $e')),
      );
    }
  }

  void _publishStory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('📤 Publish Story', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose where to publish your story:', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('📱 Publishing to app library...')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669)),
              icon: const Icon(Icons.library_books),
              label: const Text('App Library'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🌐 Publishing to web...')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
              icon: const Icon(Icons.web),
              label: const Text('Publish Online'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _previewBook() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0F0F23),
        child: Container(
          width: 600,
          height: 700,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '📖 ${widget.storyTitle}',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: PageView.builder(
                  itemCount: widget.pages.length,
                  itemBuilder: (context, index) {
                    final page = widget.pages[index];
                    return Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Page ${page.pageNumber}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                page.text,
                                style: const TextStyle(fontSize: 16, height: 1.5),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addNewPage() async {
    // Generate a new page that continues the story
    try {
      final nextPageNumber = widget.pages.length + 1;
      final lastPage = widget.pages.last;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('📝 Generating new page...')),
      );
      
      final newPage = await aiClient.generatePageText(
        page: nextPageNumber,
        idea: "Continue the story from: ${lastPage.text}",
        category: widget.genre,
        storyBible: {
          "characters": [{"name": "Alex"}], // TODO: Extract actual character name
          "continuity": "Continue from previous page: ${lastPage.text}",
          "maintain_style": true,
        },
      );
      
      final storyPage = StoryPage(
        pageNumber: nextPageNumber,
        text: newPage.lines.join('\n'),
        imagePrompt: newPage.sceneHint ?? "Children's book illustration continuing the adventure",
      );
      
      // TODO: Add page to the story (needs state management)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('📄 Added page $nextPageNumber! (Refresh to see)')),
      );
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to add page: $e')),
      );
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
