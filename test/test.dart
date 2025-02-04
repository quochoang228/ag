// import 'package:ag/src/interceptor/auth_interceptor.dart';
// import 'package:ag/src/interceptor/cache_interceptor.dart';
// import 'package:ag/src/interceptor/circuit_breaker_interceptor.dart';
// import 'package:ag/src/interceptor/connectivity_interceptor.dart';
// import 'package:ag/src/interceptor/log_interceptor.dart';
// import 'package:ag/src/interceptor/rate_limiter_interceptor.dart';
// import 'package:ag/src/interceptor/retry_interceptor.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:ag/api_gateway.dart';
// import 'package:pub/pub.dart';

// @GenerateMocks([Dio, Connectivity])
// void main() {
//   late MockDio mockDio;
//   late MockConnectivity mockConnectivity;
//   late ApiGateway apiGateway;
//   late List<Map<String, dynamic>> trackedEvents;

//   Future<String?> mockGetAccessToken() async => 'fake_token';
//   Future<String?> mockRefreshAccessToken() async => 'new_fake_token';
  
//   void mockTrackEvent(String event, Map<String, dynamic> data) {
//     trackedEvents.add({'event': event, 'data': data});
//   }

//   setUp(() {
//     mockDio = MockDio();
//     mockConnectivity = MockConnectivity();
//     trackedEvents = [];

//     apiGateway = ApiGateway(
//       getAccessToken: mockGetAccessToken,
//       refreshAccessToken: mockRefreshAccessToken,
//       connectivity: mockConnectivity,
//       onTrack: mockTrackEvent,
//     );
//   });

//   group('ApiGateway HTTP Methods', () {
//     const testPath = 'https://api.example.com/test';
//     final responseData = {'message': 'success'};
    
//     test('GET request should track events and return response', () async {
//       when(mockDio.get(testPath))
//           .thenAnswer((_) async => Response(
//                 data: responseData,
//                 statusCode: 200,
//                 requestOptions: RequestOptions(path: testPath),
//               ));

//       final response = await apiGateway.get(testPath);

//       expect(response.statusCode, 200);
//       expect(response.data, responseData);
//       expect(trackedEvents.length, 2); // Request start and success
//       expect(trackedEvents[0]['event'], contains('request'));
//       expect(trackedEvents[1]['event'], contains('success'));
//     });

//     test('POST request should track events and return response', () async {
//       final requestData = {'data': 'test'};
      
//       when(mockDio.post(testPath, data: requestData))
//           .thenAnswer((_) async => Response(
//                 data: responseData,
//                 statusCode: 201,
//                 requestOptions: RequestOptions(path: testPath),
//               ));

//       final response = await apiGateway.post(testPath, data: requestData);

//       expect(response.statusCode, 201);
//       expect(response.data, responseData);
//       expect(trackedEvents.length, 2);
//     });

//     test('PUT request should track events and return response', () async {
//       final requestData = {'data': 'test'};
      
//       when(mockDio.put(testPath, data: requestData))
//           .thenAnswer((_) async => Response(
//                 data: responseData,
//                 statusCode: 200,
//                 requestOptions: RequestOptions(path: testPath),
//               ));

//       final response = await apiGateway.put(testPath, data: requestData);

//       expect(response.statusCode, 200);
//       expect(response.data, responseData);
//       expect(trackedEvents.length, 2);
//     });

//     test('DELETE request should track events and return response', () async {
//       when(mockDio.delete(testPath))
//           .thenAnswer((_) async => Response(
//                 data: responseData,
//                 statusCode: 200,
//                 requestOptions: RequestOptions(path: testPath),
//               ));

//       final response = await apiGateway.delete(testPath);

//       expect(response.statusCode, 200);
//       expect(response.data, responseData);
//       expect(trackedEvents.length, 2);
//     });
//   });

//   group('Error Handling', () {
//     const testPath = 'https://api.example.com/test';

//     test('should track error events when request fails', () async {
//       final dioError = DioError(
//         requestOptions: RequestOptions(path: testPath),
//         error: 'Network error',
//       );

//       when(mockDio.get(testPath)).thenThrow(dioError);

//       expect(() => apiGateway.get(testPath), throwsA(isA<DioError>()));
      
//       expect(trackedEvents.length, 2); // Request start and error
//       expect(trackedEvents[0]['event'], contains('request'));
//       expect(trackedEvents[1]['event'], contains('error'));
//     });
//   });

//   group('Interceptor Configuration', () {
//     test('should initialize with all required interceptors', () {
//       final interceptors = apiGateway.dio.interceptors;
      
//       expect(interceptors.length, 7);
//       expect(interceptors.any((i) => i is LoggingInterceptor), true);
//       expect(interceptors.any((i) => i is AuthInterceptor), true);
//       expect(interceptors.any((i) => i is RateLimiterInterceptor), true);
//       expect(interceptors.any((i) => i is CacheInterceptor), true);
//       expect(interceptors.any((i) => i is RetryInterceptor), true);
//       expect(interceptors.any((i) => i is CircuitBreakerInterceptor), true);
//       expect(interceptors.any((i) => i is ConnectivityInterceptor), true);
//     });
//   });
// }