import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      isSaving = true;
    });
    try {
      final user = await UserService.getProfile();
      setState(() {
        _nameController.text = user?['name'] ?? '';
        _emailController.text = user?['email']?.toString() ?? '';
        _bioController.text = user?['bio'] ?? '';
        _imageUrlController.text = user?['imageUrl'] ?? '';
        isSaving = false;
      });
    } catch (e) {
      setState(() {
        _nameController.text = '';
        _emailController.text = '';
        _bioController.text = '';
        _imageUrlController.text = '';
        isSaving = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    setState(() {
      isSaving = true;
    });
    final success = await UserService.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      bio: _bioController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
    );
    setState(() {
      isSaving = false;
    });
    if (success && mounted) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save changes.')),
      );
    }
  }

  void _showEditPhotoModal() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile Photo'),
          content: TextField(
            controller: _imageUrlController,
            decoration: const InputDecoration(
              labelText: 'Image URL',
              hintText: 'Paste your image URL',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {}); // Para refrescar la imagen
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: _imageUrlController.text.isNotEmpty
                    ? NetworkImage(_imageUrlController.text)
                    : null,
                child: _imageUrlController.text.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: TextButton(
                onPressed: _showEditPhotoModal,
                child: const Text('Edit Profile Photo'),
              ),
            ),
            const SizedBox(height: 28.0),
            const Text('Full Name'),
            const SizedBox(height: 8.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your full name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
                ),
                filled: true,
                fillColor: Colors.blue[50],
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text('Email'),
            const SizedBox(height: 8.0),
            TextField(
              controller: _emailController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
                ),
                filled: true,
                fillColor: Colors.blue[50],
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text('Bio'),
            const SizedBox(height: 8.0),
            TextField(
              controller: _bioController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tell us about yourself',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
                ),
                filled: true,
                fillColor: Colors.blue[50],
                prefixIcon: const Icon(Icons.info_outline),
              ),
            ),
            const SizedBox(height: 36.0),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: isSaving ? 'Saving...' : 'Save Changes',
                onPressed: () => {
                  if (!isSaving) _saveChanges(),
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}