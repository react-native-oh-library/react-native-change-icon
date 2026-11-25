module.exports = {
  plugins: [
    // 先于 babel-plugin-istanbul 去掉类型，避免 spec 文件被记成 0 行
    ['@babel/plugin-transform-typescript', { allExtensions: true, onlyRemoveTypeImports: true }],
  ],
  presets: [
    ['@babel/preset-env', { targets: { node: 'current' } }],
  ],
};
