import 'package:eventio/routes/app_routes.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await UserService.getProfile();
      setState(() {
        userData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        userData = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              // TODO: Implement action for AppBar icon
            },
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : userData == null
              ? const Center(child: Text('User not found'))
              : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 32.0,
                      horizontal: 20.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24.0),
                        Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                userData!['imageUrl'] != null
                                    ? NetworkImage(userData!['imageUrl'])
                                    : null,
                            child:
                                userData!['imageUrl'] == null
                                    ? const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey,
                                    )
                                    : null,
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Center(
                          child: Text(
                            userData!['name'] ?? 'No name',
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Center(
                          child: Text(
                            (userData!['bio'] == null ||
                                    userData!['bio'].toString().trim().isEmpty)
                                ? 'No bio yet'
                                : userData!['bio'],
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ProfileStatCard(
                              label: 'attended',
                              value: '${userData!['attended'] ?? 0}',
                            ),
                            _ProfileStatCard(
                              label: 'reviews',
                              value: '${userData!['reviews'] ?? 0}',
                            ),
                            _ProfileStatCard(
                              label: 'lists created',
                              value: '${userData!['lists'] ?? 0}',
                            ),
                          ],
                        ),
                        const SizedBox(height: 36.0),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              text: 'Modify Profile',
                              onPressed: () async {
                                final updated = await Navigator.pushNamed(
                                  context,
                                  AppRoutes.editProfile,
                                );
                                if (updated == true) {
                                  _loadProfile();
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 40.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.group,
                                  color: Colors.blueAccent,
                                  size: 28,
                                ),
                                const SizedBox(width: 8.0),
                                const Text(
                                  'Friends',
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18.0),
                            (userData!['friends'] as List<dynamic>? ?? [])
                                    .isEmpty
                                ? const Text(
                                  'No friends yet',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                                : Row(
                                  children:
                                      (userData!['friends'] as List<dynamic>? ??
                                              [])
                                          .take(5)
                                          .map(
                                            (friend) => Padding(
                                              padding: const EdgeInsets.only(
                                                right: 12.0,
                                              ),
                                              child: CircleAvatar(
                                                radius: 22,
                                                backgroundColor:
                                                    Colors.grey[300],
                                                backgroundImage:
                                                    friend['imageUrl'] != null
                                                        ? NetworkImage(
                                                          friend['imageUrl'],
                                                        )
                                                        : null,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implement See all friends functionality
                            },
                            child: const Text('See all friends'),
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        Center(
                          child: InkWell(
                            onTap: () {
                              // TODO: Implement Add Friend functionality
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.person_add_alt_1),
                                SizedBox(width: 8.0),
                                Text('Add Friend'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32.0),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
