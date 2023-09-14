import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiServices {
  static Future<List<dynamic>> fetchRepositories() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.githubBaseUrl}/users/freeCodeCamp/repos'),
      headers: {
        'Authorization': 'token ${ApiConstants.githubToken}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> parsedJson = json.decode(response.body);
      return parsedJson;
    } else {
      print(response.statusCode);
      throw Exception('Failed to load repositories');
    }
  }

  static Future<String> fetchLastCommit(String repoName) async {
    final commitsUrl = '${ApiConstants.githubBaseUrl}/repos/freeCodeCamp/$repoName/commits';
    final response = await http.get(
      Uri.parse(commitsUrl),
      headers: {
        'Authorization': 'token ${ApiConstants.githubToken}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> commits = json.decode(response.body);
      if (commits.isNotEmpty) {
        return commits[0]['commit']['message'];
      } else {
        return 'No commits';
      }
    } else {
      throw Exception('Failed to load commits');
    }
  }
}
