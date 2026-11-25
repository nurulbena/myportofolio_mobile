import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  test('getProjects parses snake_case JSON and defaults null urls', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/v1/projects/');
      return http.Response(
        jsonEncode([
          {
            'id': 'abc',
            'title': 'Portfolio',
            'description': 'My website',
            'tech_stack': 'Django',
            'project_url': null,
            'project_image_url': null,
          },
        ]),
        200,
      );
    });
    final api = ApiClient(client: client, baseUrl: 'http://test');

    final projects = await api.getProjects();

    expect(projects, hasLength(1));
    expect(projects.first.id, 'abc');
    expect(projects.first.techStack, 'Django');
    expect(projects.first.projectUrl, '');
    expect(projects.first.projectImageUrl, '');
  });

  test('createProject sends the token and omits the id', () async {
    final client = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.headers['Authorization'], 'Token secret');
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      expect(body.containsKey('id'), isFalse);
      expect(body['tech_stack'], 'Flutter');
      return http.Response(jsonEncode({'id': 'new', ...body}), 201);
    });
    final api = ApiClient(client: client, baseUrl: 'http://test');

    final created = await api.createProject(
      const Project(
        title: 'App',
        description: 'Desc',
        techStack: 'Flutter',
        projectUrl: 'https://example.com',
      ),
      token: 'secret',
    );

    expect(created.id, 'new');
  });

  test('non-2xx responses throw ApiException', () async {
    final client = MockClient((request) async => http.Response('nope', 401));
    final api = ApiClient(client: client, baseUrl: 'http://test');

    expect(
      api.obtainToken('u', 'p'),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 401)),
    );
  });
}
