const path = require("path")
const glob = require("glob")
const UglifyJsPlugin = require("uglifyjs-webpack-plugin")
const OptimizeCSSAssetsPlugin = require("optimize-css-assets-webpack-plugin")
const CopyWebpackPlugin = require("copy-webpack-plugin")

module.exports = (env, options) => ({
  optimization: {
    minimizer: [
      new UglifyJsPlugin({ cache: true, parallel: true, sourceMap: false }),
    ]
  },
  entry: {
    "app": ["./js/app.js"].concat(glob.sync("./vendor/**/*.js")),
  },
  output: {
    filename: "[name].js",
    path: path.resolve(__dirname, "../priv/static/js")
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: { loader: "babel-loader"}
      },
    ]
  },
  plugins: [new CopyWebpackPlugin([{ from: "static/", to: "../" }])]
})
