import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../services/api_services.dart';

class HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> repositories = [];

  @override
  void initState() {
    super.initState();
    fetchRepositories();
  }

  Future<void> fetchRepositories() async {
    try {
      final newRepositories = await ApiServices.fetchRepositories();
      setState(() {
        repositories = List<Map<String, dynamic>>.from(newRepositories);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String> fetchLastCommit(String repoName) async {
    try {
      final lastCommit = await ApiServices.fetchLastCommit(repoName);
      return lastCommit;
    } catch (e) {
      return 'Error: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Github Scrap'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Github Account: FreeCodeCamp",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                "Public Repo List",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: ListView.builder(
                  itemCount: repositories.length,
                  itemBuilder: (context, index) {
                    final repo = repositories[index];
                    return ListTile(
                      title: Text(repo['name']),
                      subtitle: FutureBuilder(
                        future: fetchLastCommit(repo['name']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error : ${snapshot.error}');
                          } else {
                            final lastCommit = snapshot.data;
                            return Text('LastCommit: $lastCommit');
                          }
                        },
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
}
