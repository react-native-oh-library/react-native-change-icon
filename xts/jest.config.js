const path = require('path');

/** @type {import('jest').Config} */
module.exports = {
  rootDir: path.resolve(__dirname, '..'),
  testEnvironment: 'node',
  coverageProvider: 'v8',
  testMatch: ['<rootDir>/xts/__tests__/**/*-test.js'],
  watchman: false,
  moduleNameMapper: {
    '^react-native$': '<rootDir>/xts/mocks/react-native.js',
  },
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node'],
  collectCoverageFrom: ['src/index.ts', 'src/specs/v1/NativeChangeIcon.ts'],
  coverageDirectory: '<rootDir>/xts/coverage',
  coverageThreshold: {
    global: {
      branches: 90,
      functions: 90,
      lines: 90,
      statements: 90,
    },
  },
  transform: {
    '^.+\\.[jt]sx?$': [
      'babel-jest',
      { configFile: path.resolve(__dirname, 'babel.config.js') },
    ],
  },
};
