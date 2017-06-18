/* eslint-disable */
var yog = require('yog2-kernel');
var util = yog.require('common/libs/util');

var renderPage = function (req, res, next) {
    var template = 'home/page/jsinvoke.tpl';
    res.render(template);
}

module.exports = renderPage;
