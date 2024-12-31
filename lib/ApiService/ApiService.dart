import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ApiService {
  final String _baseUrl = 'https://projects.funtashtechnologies.com/gomeetapi';

  // Register User
  // Future<Map<String, dynamic>> registerUser({
  //   required String firstname,
  //   required String lastname,
  //   required String gender,
  //   required String dateofbirth,
  //   required String height,
  //   required String maritalstatus,
  //   required String religion,
  //   required String religionlookingfor,
  //   required String nationality,
  //   required String nationalitylookingfor,
  //   required String education,
  //   required String educationlookingfor,
  //   required String city,
  //   required String citylookingfor,
  //   required String cast,
  //   required String castlookingfor,
  //   required String subcast,
  //   required String subcastlookingfor,
  //   required String sect,
  //   required String sectlookingfor,
  //   required String subsect,
  //   required String subsectlookingfor,
  //   required String ethnicity,
  //   required String ethnicitylookingfor,
  //   required File profileimage,
  // }) async {
  //   try {
  //     // Prepare the request URL
  //     final Uri  url = Uri.parse('$_baseUrl/registeration.php');
  //     print("Url : $url");
  //
  //     // Create the request body as a Map
  //     Map<String, dynamic> requestData = {
  //       'firstname': firstname,
  //       'lastname': lastname,
  //       'gender': gender,
  //       'dateofbirth': dateofbirth,
  //       'height': height,
  //       'maritalstatus': maritalstatus,
  //       'religion': religion,
  //       'religionlookingfor': religionlookingfor,
  //       'nationality': nationality,
  //       'nationalitylookingfor': nationalitylookingfor,
  //       'education': education,
  //       'educationlookingfor': educationlookingfor,
  //       'city': city,
  //       'citylookingfor': citylookingfor,
  //       'cast': cast,
  //       'castlookingfor': castlookingfor,
  //       'subcast': subcast,
  //       'subcastlookingfor': subcastlookingfor,
  //       'sect': sect,
  //       'sectlookingfor': sectlookingfor,
  //       'subsect': subsect,
  //       'subsectlookingfor': subsectlookingfor,
  //       'ethnicity': ethnicity,
  //       'ethnicitylookingfor': ethnicitylookingfor,
  //       'profileimage': profileimage.path,
  //     };
  //
  //     // Send the POST request with JSON content type
  //     final response = await http.post(url, body: jsonEncode(requestData));
  //
  //     print(response.body); // Log the response body
  //
  //     // Check the response status code
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       // Check if registration was successful
  //       if (data['ResponseCode'] == 200) {
  //         return {'success': 'Registration successful!'};
  //       } else {
  //         return {'error': data['ResponseMsg']};
  //       }
  //     } else {
  //       return {'error': 'Failed to reach server, status code: ${response.statusCode}'};
  //     }
  //   } catch (e) {
  //     return {'error': 'Error: $e'};
  //   }
  // }

  Future<Map<String, dynamic>> registerUser({
    required String firstname,
    required String lastname,
    required String gender,
    required String dateofbirth,
    required String height,
    required String maritalstatus,
    required String religion,
    required String religionlookingfor,
    required String nationality,
    required String nationalitylookingfor,
    required String education,
    required String educationlookingfor,
    required String city,
    required String citylookingfor,
    required String cast,
    required String castlookingfor,
    required String subcast,
    required String subcastlookingfor,
    required String sect,
    required String sectlookingfor,
    required String subsect,
    required String subsectlookingfor,
    required String ethnicity,
    required String ethnicitylookingfor,
    required File profileimage,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/registeration.php');
      final request = http.MultipartRequest('POST', url);

      // Add text fields
      request.fields['firstname'] = firstname;
      request.fields['lastname'] = lastname;
      request.fields['gender'] = gender;
      request.fields['dateofbirth'] = dateofbirth;
      request.fields['height'] = height;
      request.fields['maritalstatus'] = maritalstatus;
      request.fields['religion'] = religion;
      request.fields['religionlookingfor'] = religionlookingfor;
      request.fields['nationality'] = nationality;
      request.fields['nationalitylookingfor'] = nationalitylookingfor;
      request.fields['education'] = education;
      request.fields['educationlookingfor'] = educationlookingfor;
      request.fields['city'] = city;
      request.fields['citylookingfor'] = citylookingfor;
      request.fields['cast'] = cast;
      request.fields['castlookingfor'] = castlookingfor;
      request.fields['subcast'] = subcast;
      request.fields['subcastlookingfor'] = subcastlookingfor;
      request.fields['sect'] = sect;
      request.fields['sectlookingfor'] = sectlookingfor;
      request.fields['subsect'] = subsect;
      request.fields['subsectlookingfor'] = subsectlookingfor;
      request.fields['ethnicity'] = ethnicity;
      request.fields['ethnicitylookingfor'] = ethnicitylookingfor;

      // Add the file field
      request.files.add(
        await http.MultipartFile.fromPath(
          'profileimage', // Key name expected by the server
          profileimage.path,
        ),
      );

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        final parsedBody = jsonDecode(responseBody);
        // Extract the 'userid' and save it
        if (parsedBody['Userid'] != null) {
          int userId = int.parse(parsedBody['Userid'].toString());
          print(" Register Successfully User ID: $userId");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('userid', userId);
        }
        print('Response: $responseBody');
        return {'ResponseCode': '200', 'Result': 'true', 'ResponseMsg': 'Success'};
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Error Response: $responseBody');
        return {'ResponseCode': response.statusCode.toString(), 'Result': 'false', 'ResponseMsg': 'Failed'};
      }
    } catch (e) {
      print('Error occurred: $e');
      return {'ResponseCode': '500', 'Result': 'false', 'ResponseMsg': e.toString()};
    }
  }

  // create a post request to get user with userid and api endpoints is getusers.php

  Future<Map<String, dynamic>> getUsers({required String userId}) async {
    try {
      final url = Uri.parse('$_baseUrl/getusers.php');
      final request = http.MultipartRequest('POST', url);

      // Add text fields
      request.fields['userid'] = userId;

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonData = json.decode(responseBody);

        if (jsonData['ResponseCode'] == '200') {
          // Return full response including `Data` array
          return {
            'ResponseCode': jsonData['ResponseCode'],
            'Result': jsonData['Result'],
            'ResponseMsg': jsonData['ResponseMsg'],
            'Data': jsonData['Data']
          };
        } else {
          return {
            'ResponseCode': jsonData['ResponseCode'],
            'Result': jsonData['Result'],
            'ResponseMsg': jsonData['ResponseMsg'],
            'Data': []
          };
        }
      } else {
        return {
          'ResponseCode': response.statusCode.toString(),
          'Result': 'false',
          'ResponseMsg': 'Failed to fetch users',
          'Data': []
        };
      }
    } catch (e) {
      return {
        'ResponseCode': '500',
        'Result': 'false',
        'ResponseMsg': e.toString(),
        'Data': []
      };
    }
  }

  // Post request to get send connection request data
  Future<Map<String, dynamic>> getSendConRequest({required String userId}) async {
    try {
      final url = Uri.parse('$_baseUrl/getreceiveconrequestusers.php');

      // Create the request body with the userId
      final response = await http.post(
        url,
        body: {'userid': userId},
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody['ResponseCode'] == '200') {
          // Return the response if successful, including the Data array
          return {
            'ResponseCode': responseBody['ResponseCode'],
            'Result': responseBody['Result'],
            'ResponseMsg': responseBody['ResponseMsg'],
            'Data': responseBody['Data'],
          };
        } else {
          // If response code is not 200, return failure details
          return {
            'ResponseCode': responseBody['ResponseCode'],
            'Result': responseBody['Result'],
            'ResponseMsg': responseBody['ResponseMsg'],
            'Data': [],
          };
        }
      } else {
        // Return failure if status code is not 200
        return {
          'ResponseCode': response.statusCode.toString(),
          'Result': 'false',
          'ResponseMsg': 'Failed to fetch connection requests',
          'Data': [],
        };
      }
    } catch (e) {
      // Return error response if an exception occurs
      return {
        'ResponseCode': '500',
        'Result': 'false',
        'ResponseMsg': e.toString(),
        'Data': [],
      };
    }
  }

  // Method to send a connection request
  Future<Map<String, dynamic>> sendConnectionRequest({
    required String userId,
    required String connectionId,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/sendconnectionreq.php');
      final response = await http.post(
        url,
        body: {
          'userid': userId,
          'connectionid': connectionId,
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody['ResponseCode'] == '200') {
          // Connection request sent successfully
          return {
            'ResponseCode': responseBody['ResponseCode'],
            'Result': responseBody['Result'],
            'ResponseMsg': responseBody['ResponseMsg'],
          };
        } else {
          // Handle other response codes
          return {
            'ResponseCode': responseBody['ResponseCode'],
            'Result': 'false',
            'ResponseMsg': responseBody['ResponseMsg'],
          };
        }
      } else {
        // API call failed
        return {
          'ResponseCode': response.statusCode.toString(),
          'Result': 'false',
          'ResponseMsg': 'Failed to send connection request.',
        };
      }
    } catch (e) {
      // Handle errors
      return {
        'ResponseCode': '500',
        'Result': 'false',
        'ResponseMsg': e.toString(),
      };
    }
  }

  // create a method for get pending request
  Future<Map<String, dynamic>> getPendingRequests({required String userid}) async {
    try {
      final url = Uri.parse('$_baseUrl/getsendconrequest.php');
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody['ResponseCode'] == '200') {
          // Return the response if successful, including the Data array
          return {
            'ResponseCode': responseBody['ResponseCode'],
            'Result': responseBody['Result'],
            'ResponseMsg': responseBody['ResponseMsg'],
            'Data': responseBody['Data'],
          };
        } else {
          // If response code is not 200, return failure details
          return {
            'ResponseCode': responseBody['ResponseCode'],
            'Result': responseBody['Result'],
            'ResponseMsg': responseBody['ResponseMsg'],
            'Data': [],
          };
        }
      } else {
        // Return failure if status code is not 200
        return {
          'ResponseCode': response.statusCode.toString(),
          'Result': 'false',
          'ResponseMsg': 'Failed to fetch connection requests',
          'Data': [],
        };
      }
    } catch (e) {
      // Return error response if an exception occurs
      return {
        'ResponseCode': '500',
        'Result': 'false',
        'ResponseMsg': e.toString(),
        'Data': [],
      };
    }
  }
}
