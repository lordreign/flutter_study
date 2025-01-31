import 'dart:io';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

final ip = Platform.isAndroid ? '10.0.2.2:3000' : '127.0.0.1:3000';
// '10.0.2.2' > emulator IP (android)
// '127.0.0.1' > simulator (ios)
