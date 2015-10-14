
// MARK: - Constructor

function H24HybridLogger(callbacker, parameterSeparator) {
    this.callbacker = callbacker;
    this.parameterSeparator = parameterSeparator;
};

// MARK: - Logging

H24HybridLogger.prototype.log = function(msg) {
    this.callbacker.callback('callback-log', 'msg=' + msg);
};

H24HybridLogger.prototype.logError = function(msg, url, line) {
    
    var arguments = ["msg=" + msg,
                     "url=" + url,
                     "line=" + line];
    var joinedArguments = arguments.join(this.parameterSeparator);
    
    this.callbacker.callback('callback-log-error', joinedArguments);
};