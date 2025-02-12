import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Assisment.dart';
import '../Models/Casts.dart';
import '../Models/GoalTarget.dart';
import '../Models/GoaltargetQuestions.dart';
import '../Models/Questions.dart';

class ApiService {
  static const String _baseUrl =
      "https://projects.funtashtechnologies.com/gomeetapi";

  Future<Map<String, dynamic>> registerUser({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
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
    required String employmentstatus,
    required String monthlyincome,
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
    required String created_at,
    required File profileimage,
    required File cnic_front,
    required File cnic_back,
    required File passport_front,
    required File passport_back,
    required File selfieimage,
    required File gallery,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/registeration.php');
      final request = http.MultipartRequest('POST', url);

      // Add text fields
      request.fields['firstname'] = firstname;
      request.fields['lastname'] = lastname;
      request.fields['email'] = email;
      request.fields['password'] = password;
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
      request.fields['employmentstatus'] = employmentstatus;
      request.fields['monthlyincome'] = monthlyincome;
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
      request.fields['created_at'] = created_at;

      // Add the file field
      request.files.add(
        await http.MultipartFile.fromPath(
          'profileimage', // Key name expected by the server
          profileimage.path,
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'gallery', // Key name expected by the server
          gallery.path,
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'cnic_front', // Key name expected by the server
          cnic_front.path,
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'cnic_back', // Key name expected by the server
          cnic_back.path,
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'passport_front', // Key name expected by the server
          passport_front.path,
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'passport_back', // Key name expected by the server
          passport_back.path,
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'selfieimage', // Key name expected by the server
          selfieimage.path,
        ),
      );

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        final parsedBody = jsonDecode(responseBody);
        // Extract the 'userid' and save it
        if (parsedBody['userid'] != null) {
          int userId = int.parse(parsedBody['userid'].toString());
          if (kDebugMode) {
            print(" Register Successfully User ID: $userId");
          }
          // final prefs = await SharedPreferences.getInstance();
          // prefs.setString('userid', userId.toString());
          if (kDebugMode) {
            print(
                "================================ user succesfully registered user id  : $userId========================================");
            print('Response: $responseBody');
          }
        }
        return {
          'ResponseCode': '200',
          'Result': 'true',
          'ResponseMsg': 'Success',
          'Data': parsedBody
        };
      } else {
        final responseBody = await response.stream.bytesToString();
        if (kDebugMode) {
          print('Error Response: $responseBody');
        }
        return {
          'ResponseCode': response.statusCode.toString(),
          'Result': 'false',
          'ResponseMsg': 'Failed'
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      return {
        'ResponseCode': '500',
        'Result': 'false',
        'ResponseMsg': e.toString()
      };
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final url = Uri.parse(
        '${_baseUrl}/login.php'); // Replace with actual login endpoint

    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load login data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  // create a post request to get user with userid and api endpoints is getusers.php

  Future<Map<String, dynamic>> getUsers({required String userId}) async {
    try {
      final url = Uri.parse('$_baseUrl/getusers.php');
      final response = await http.post(
        url,
        body: {'userid': userId},
      );

      if (response.statusCode == 200) {
        // final responseBody = await response.stream.bytesToString();
        //         // final jsonData = json.decode(responseBody);

        final jsonData = json.decode(response.body);

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

  void printFullText(String text) {
    final pattern =
        RegExp('.{1,800}'); // Breaks the text into chunks of 800 characters
    for (final match in pattern.allMatches(text)) {
      if (kDebugMode) {
        print(match.group(0));
      } // Print each chunk
    }
  }

  // Post request to get send connection request data
  Future<Map<String, dynamic>> getSendConRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString("userid");

      if (userId == null || userId.isEmpty) {
        return {
          'ResponseCode': '400',
          'Result': 'false',
          'ResponseMsg': 'User ID not found',
          'Data': [],
        };
      }

      final url = Uri.parse('$_baseUrl/getreceiveconrequestusers.php');

      if (kDebugMode) {
        print('Request body: ${jsonEncode({'userid': userId})}');
      }

      final response = await http.post(
        url,
        body: {'userid': userId},
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (kDebugMode) {
          printFullText('Full response: ${jsonEncode(responseBody)}');
        }

        if (responseBody['ResponseCode'] == '200') {
          // Ensure `Data` is a list before returning
          final data = responseBody['Data'];
          if (data is List) {
            return {
              'ResponseCode': responseBody['ResponseCode'],
              'Result': responseBody['Result'],
              'ResponseMsg': responseBody['ResponseMsg'],
              'Data': data,
            };
          } else {
            return {
              'ResponseCode': responseBody['ResponseCode'],
              'Result': 'false',
              'ResponseMsg': 'Invalid data format',
              'Data': [],
            };
          }
        } else {
          return {
            'ResponseCode': responseBody['ResponseCode'],
            'Result': responseBody['Result'],
            'ResponseMsg': responseBody['ResponseMsg'],
            'Data': [],
          };
        }
      } else {
        return {
          'ResponseCode': response.statusCode.toString(),
          'Result': 'false',
          'ResponseMsg': 'HTTP request failed',
          'Data': [],
        };
      }
    } catch (e) {
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
  Future<Map<String, dynamic>> getPendingRequests() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String userid = prefs.getString("userid").toString();
      final url = Uri.parse('$_baseUrl/getsendconrequest.php');
      final response = await http.post(url, body: {
        'userid': userid,
      });

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

  // Get user data by user id
  Future<Map<String, dynamic>> GetUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userid = prefs.getString('userid').toString();
      print(
          "================================ User id is :$userid  in Get User Info ========================================");
      final url = Uri.parse('$_baseUrl/getprofiledata.php');
      final response = await http.post(url, body: {'userId': userid});

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody['ResponseCode'] == '200') {
          // Return the response if successful, including the Data array
          return {
            'ResponseCode': responseBody['ResponseCode'],
            'Result': responseBody['Result'],
            'ResponseMsg': responseBody['ResponseMsg'],
            'UserData': responseBody['UserData'],
          };
        } else {
          // If response code is not 200, return failure details
          return {
            'ResponseCode': responseBody['ResponseCode'],
            'Result': responseBody['Result'],
            'ResponseMsg': responseBody['ResponseMsg'],
            'UserData': [],
          };
        }
      } else {
        // Return failure if status code is not 200
        return {
          'ResponseCode': response.statusCode.toString(),
          'Result': 'false',
          'ResponseMsg': 'Failed to fetch user data',
          'UserData': [],
        };
      }
    } catch (e) {
      // Return error response if an exception occurs
      return {
        'ResponseCode': '500',
        'Result': 'false',
        'ResponseMsg': e.toString(),
        'UserData': [],
      };
    }
  }

  Future<Map<String, dynamic>> acceptRequest({
    required String userId,
    required String connectionId,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/acceptrequest.php');
      final response = await http.post(
        url,
        body: {
          'userid': userId,
          'connectionuserid': connectionId,
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody['ResponseCode'] == '200') {
          return {
            'ResponseCode': responseBody['ResponseCode'],
            'Result': responseBody['Result'],
            'ResponseMsg': responseBody['ResponseMsg'],
          };
        } else {
          // If API response indicates a failure
          return {
            'ResponseCode': responseBody['ResponseCode'],
            'Result': responseBody['Result'],
            'ResponseMsg': responseBody['ResponseMsg'],
          };
        }
      } else {
        // If HTTP response status code is not 200
        return {
          'ResponseCode': response.statusCode.toString(),
          'Result': 'false',
          'ResponseMsg': 'Failed to accept request',
        };
      }
    } catch (e) {
      // If an exception occurs
      return {
        'ResponseCode': '500',
        'Result': 'false',
        'ResponseMsg': e.toString(),
      };
    }
  }

  // create a method for get connection by user id and with end point getconnections.php
  Future<Map<String, dynamic>> getConnections() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userid = prefs.getString('userid').toString();
      if (kDebugMode) {
        print(
            "================================ User id is :$userid  in Get Connections ========================================");
      }

      final url = Uri.parse('$_baseUrl/getconnections.php');
      final response = await http.post(
        url,
        body: {'userId': userid},
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody['ResponseCode'] == '200') {
          // Return the response if successful, including the Data array
          return {
            'ResponseCode': responseBody['ResponseCode'],
            'Result': responseBody['Result'],
            'ResponseMsg': responseBody['ResponseMsg'],
            'ConnectionsData': responseBody['ConnectionsData'],
          };
        } else {
          // If response code is not 200, return failure details
          return {
            'ResponseCode': responseBody['ResponseCode'],
            'Result': responseBody['Result'],
            'ResponseMsg': responseBody['ResponseMsg'],
            'ConnectionsData': [],
          };
        }
      } else {
        // Return failure if status code is not 200
        return {
          'ResponseCode': response.statusCode.toString(),
          'Result': 'false',
          'ResponseMsg': 'Failed to fetch connections',
          'ConnectionsData': [],
        };
      }
    } catch (e) {
      // Return error response if an exception occurs
      return {
        'ResponseCode': '500',
        'Result': 'false',
        'ResponseMsg': e.toString(),
        'ConnectionsData': [],
      };
    }
  }

  // Fetch categories from API
  Future<List<AssessmentCategory>> fetchAssessmentCategories() async {
    try {
      final response =
          await http.get(Uri.parse("$_baseUrl/getassesmentcategories.php"));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData['ResponseCode'] == "200" && jsonData['Result'] == "true") {
          List categoriesData = jsonData['Data'];
          return categoriesData
              .map((category) => AssessmentCategory.fromJson(category))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception("Failed to load categories");
      }
    } catch (e) {
      throw Exception("Error fetching categories: $e");
    }
  }

  static Future<List<Question>> fetchAssessmentQuestions() async {
    final url = Uri.parse("$_baseUrl/getassesmentquestions.php");
    final response = await GetConnect().get(url.toString());

    if (response.statusCode == 200 && response.body['Result'] == 'true') {
      final List<dynamic> data = response.body['Data'];
      return data.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load questions");
    }
  }

  Future<List<GoalTarget>> fetchGoalTargets() async {
    final response = await http.get(Uri.parse('$_baseUrl/getgoaltargets.php'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['Result'] == "true") {
        return (jsonResponse['Data'] as List)
            .map((data) => GoalTarget.fromJson(data))
            .toList();
      }
    }

    throw Exception("Failed to fetch Goal Targets");
  }

  Future<List<GoaltargetQuestions>> fetchGoalTargetQuestions() async {
    final url = Uri.parse("$_baseUrl/getgoaltargetquestions.php");
    final response = await GetConnect().get(url.toString());

    if (response.statusCode == 200 && response.body['Result'] == 'true') {
      final List<dynamic> data = response.body['Data'];
      return data.map((json) => GoaltargetQuestions.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load questions");
    }
  }

  // Fetch country list from API
  Future<List<String>> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/getcountry.php"));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData["Result"] == "true") {
          List<dynamic> data = jsonData["Data"];
          return data.map((item) => item["country"].toString()).toList();
        } else {
          return [];
        }
      } else {
        throw Exception("Failed to load countries");
      }
    } catch (e) {
      print("Error fetching countries: $e");
      return [];
    }
  }

  Future<List<String>> fetchReligions() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/getreligion.php"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Result'] == "true") {
          return List<String>.from(
              data['Data'].map((item) => item['religion']));
        }
      }
    } catch (e) {
      print("Error fetching religions: $e");
    }
    return [];
  }

  Future<List<String>> fetchCities(String countryName) async {
    try {
      final url = Uri.parse('${_baseUrl}/getcities.php');
      print('URL for Request : $url');
      print('Country Name for Request : $countryName');
      final response = await http.post(
        url,
        body: {'countryname': countryName},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<String> cities = data['Data']
            .map<String>((city) => city['city'].toString())
            .toList();
        return cities;
      } else {
        throw Exception('Failed to load cities');
      }
    } catch (e) {
      print('Error fetching cities: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchCastData(String religion) async {
    final url = Uri.parse('$_baseUrl/getcast.php');
    final response = await http.post(url, body: {'religion': religion});

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['ResponseCode'] == "200" &&
          jsonResponse['Result'] == "true") {
        return List<Map<String, dynamic>>.from(jsonResponse['Data']);
      } else {
        throw Exception('Failed to fetch data: ${jsonResponse['ResponseMsg']}');
      }
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  Future<List<String>> fetchSectData(
      {required String religion, required String caste}) async {
    final url = Uri.parse("$_baseUrl/getsect.php");

    try {
      final response = await http.post(
        url,
        body: {
          "religion": religion,
          "cast": caste,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData["Result"] == "true") {
          return (responseData["Data"] as List)
              .map<String>((sect) => sect["sect"].toString())
              .toList();
        } else {
          throw Exception(responseData["ResponseMsg"]);
        }
      } else {
        throw Exception(
            "Failed to fetch sects. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching sects: $e");
    }
  }

  // Fetch Rating Percentage

  static Future<double?> fetchRatingPercentage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userid');

      print("User in to get rating: $userId");

      if (userId == null || userId.isEmpty) {
        print("Error: User ID is null or empty!");
        return null;
      }

      final response = await http.post(
        Uri.parse(
            "https://projects.funtashtechnologies.com/gomeetapi/getratings.php"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"userid": userId},
      );

      final responseData = jsonDecode(response.body);
      print("Rating API Response: $responseData");

      if (response.statusCode == 200 && responseData["Result"] == "true") {
        return double.tryParse(responseData["RatingPercentage"].toString());
      }
    } catch (e) {
      print("Error fetching rating percentage: $e");
    }

    return null;
  }

  static Future<Map<String, dynamic>> submitAnswer({
    required String userId,
    required int categoryId,
    required String questionId,
    required String type,
    required String answer,
  }) async {
    try {
      Map<String, dynamic> payload = {
        "userid": userId,
        "type": type,
        "categoryid": categoryId.toString(),
        "questionid": questionId.toString(),
        "answer": answer,
      };

      if (kDebugMode) {
        print("Submitting Answer: $payload");
      }

      final response = await http.post(
        Uri.parse(
            "https://projects.funtashtechnologies.com/gomeetapi/answerassesmentquestions.php"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: payload.map((key, value) => MapEntry(key, value.toString())),
      );

      final responseData = jsonDecode(response.body);
      print("API Response: $responseData");

      return responseData;
    } catch (e) {
      print("API Error: $e");
      return {"Result": false, "ResponseMsg": "An unexpected error occurred."};
    }
  }
}
