
// String getCountryCode(String countryName) {
//   // Get the country list
//   final List<Country> countries = Countries.all();
//
//   // Find the matching country by name
//   final country = countries.firstWhere(
//         (c) => c.name.common.toLowerCase() == countryName.toLowerCase(),
//     orElse: () => Country(cca2: 'US'), // Default to 'US'
//   );
//
//   return country.cca2 ?? 'US'; // ISO Alpha-2 Code (e.g., "US", "DE")
// }
