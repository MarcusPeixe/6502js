ace.define("ace/mode/assembly_6502_highlight_rules",["require","exports","module","ace/lib/oop","ace/mode/text_highlight_rules"], function(require, exports, module) {
"use strict";

var oop = require("../lib/oop");
var TextHighlightRules = require("./text_highlight_rules").TextHighlightRules;

var Assembly6502HighlightRules = function() {
    var keywords = 
        "(?:ADC|AND|ASL|BCC|BCS|BEQ|BIT|BMI|BNE|BPL|BRK|BVC|BVS|CLC|CLD|CLI|CLV|CMP|CPX|CPY|DEC|DEX|DEY|EOR|INC|INX|INY|JMP|JSR|LDA|LDX|LDY|LSR|NOP|ORA|PHA|PHP|PLA|PLP|ROL|ROR|RTI|RTS|SBC|SEC|SED|SEI|STA|STX|STY|TAX|TAY|TSX|TXA|TXS|TYA|WDM)";
    this.$rules = {
          "start" : [
              {token : "keyword.operator", regex : "DEFINE", next : "ident"},
              {token : "keyword.operator", regex : "DCB", next : "constbyte"},
              {token : "variable.parameter", regex : "\\*", next : "equalsign"},
              {token : "variable.parameter",  regex : "\\b(res|irq|nmi):", next : "start"},
              {token : "support.function",  regex : "\\b[a-z_]+[a-z0-9_]*:", next : "start"},
              {token : "comment",  regex : ";.*$", next : "start"},
              {token : "keyword", regex : keywords, next : "param"},
              {caseInsensitive: true}
          ],
          "constbyte" : [
              // {token : "variable", regex: "[a-z_]+[a-z0-9_]*?\\b", next : "comma3"},
              {token : "constant.numeric", regex: "[$][A-F0-9]{2}\\b", next : "comma3"},
              {token : "constant.numeric", regex: "[$][A-F0-9]{4}\\b", next : "comma3"},
              {token : "constant.numeric", regex: "[%][01]{8}\\b", next : "comma3"},
              {token : "constant.numeric", regex: "[%][01]{16}\\b", next : "comma3"},
              {token : "constant.numeric", regex: "[0-9]{1,5}\\b", next : "comma3"},
              {caseInsensitive: true}
          ],
          "ident" : [
              {token : "support.function", regex: "[a-z_]+[a-z0-9_]*?\\b", next : "identvalue"},
              {caseInsensitive: true}
          ],
          "identvalue" : [
              {token : "constant.numeric", regex: "#?[$][A-F0-9]{2}\\b", next : "start"},
              {token : "constant.numeric", regex: "#?[$][A-F0-9]{4}\\b", next : "start"},
               {token : "constant.numeric", regex: "#?[%][01]{8}\\b", next : "start"},
              {token : "constant.numeric", regex: "#?[%][01]{16}\\b", next : "start"},
              {token : "constant.numeric", regex: "#?[0-9]{1,5}\\b", next : "start"},
              {caseInsensitive: true}
          ],
          "param" : [
              // Return to start
              {token : "newline",  regex : "^", next : "start"},
              {token : "comment",  regex : ";.*?$", next : "start"},
              {token : "variable.parameter",  regex : "A", next : "start"},
              
              // Get a value
              {token : "keyword.operator",  regex : "[(]", next : "value"},
              
              // Get a comma or newline
              // {token : "variable.parameter", regex: "(x|y)", next : "comma"},
              {token : "constant.numeric", regex: "#?[$][A-F0-9]{2}\\b", next : "comma"},
              {token : "constant.numeric", regex: "#?[$][A-F0-9]{4}\\b", next : "comma"},
               {token : "constant.numeric", regex: "#?[%][01]{8}\\b", next : "comma"},
              {token : "constant.numeric", regex: "#?[%][01]{16}\\b", next : "comma"},
              {token : "constant.numeric", regex: "#?[0-9]{1,5}\\b", next : "comma"},
              {token : "variable", regex: "#(?=[<>])", next : "hilo"},
              {token : "variable", regex: "#?[a-z_]+[a-z0-9_]*?\\b", next : "comma"},
              {caseInsensitive: true}
          ],
          "value" : [
              // Get a comma or closing parentheses
              // {token : "variable.parameter", regex: "(x|y)", next : "comma2"},
              {token : "constant.numeric", regex: "#?[$][A-F0-9]{2}\\b", next : "comma2"},
              {token : "constant.numeric", regex: "#?[$][A-F0-9]{4}\\b", next : "comma2"},
               {token : "constant.numeric", regex: "#?[%][01]{8}\\b", next : "comma2"},
              {token : "constant.numeric", regex: "#?[%][01]{16}\\b", next : "comma2"},
              {token : "constant.numeric", regex: "#?[0-9]{1,5}\\b", next : "comma2"},
              {token : "variable", regex: "#(?=[<>])", next : "hilo2"},
              {token : "variable", regex: "#?[a-z_]+[a-z0-9_]*?\\b", next : "comma2"},
              {caseInsensitive: true}
          ],
          "constvalue" : [
              // Return to start
              {token : "constant.numeric", regex: "[$][A-F0-9]{2}\\b", next : "start"},
              {token : "constant.numeric", regex: "[$][A-F0-9]{4}\\b", next : "start"},
               {token : "constant.numeric", regex: "[%][01]{8}\\b", next : "start"},
              {token : "constant.numeric", regex: "[%][01]{16}\\b", next : "start"},
              {token : "constant.numeric", regex: "[0-9]{1,5}\\b", next : "start"},
              {caseInsensitive: true}
          ],
          "hilo" : [
              // Get HI/LO suffix
              {token : "keyword", regex: "[<>]", next : "hilo_label"},
              {caseInsensitive: true}
          ],
          "hilo2" : [
              // Get HI/LO suffix
              {token : "keyword", regex: "[<>]", next : "hilo_label2"},
              {caseInsensitive: true}
          ],
          "hilo_label" : [
              // Get rest of operand
              {token : "variable", regex: "[a-z_]+[a-z0-9_]*?\\b", next : "comma"},
              {caseInsensitive: true}
          ],
          "hilo_label2" : [
              // Get rest of operand
              {token : "variable", regex: "[a-z_]+[a-z0-9_]*?\\b", next : "comma2"},
              {caseInsensitive: true}
          ],
          "reg" : [
              // Get a comma or closing parentheses
              {token : "variable.parameter", regex: "(x|y)", next : "start"},
              {caseInsensitive: true}
          ],
          "reg2" : [
              // Get a comma or closing parentheses
              {token : "variable.parameter", regex: "(x|y)", next : "close"},
              {caseInsensitive: true}
          ],
          "comma" : [
              {token : "keyword.operator",  regex : "[,]", next : "reg"},
              {token : "keyword.operator",  regex : "^", next : "start"},
              {token : "comment",  regex : ";.*$", next : "start"},
          ],
          "comma2" : [
              {token : "keyword.operator",  regex : "[,]", next : "reg2"},
              {token : "keyword.operator",  regex : "[)]", next : "comma"},
          ],
          "comma3" : [
              {token : "keyword.operator",  regex : "[,]", next : "constbyte"},
              {token : "keyword.operator",  regex : "^", next : "start"},
              {token : "comment",  regex : ";.*$", next : "start"},
          ],
          "close" : [
              {token : "keyword.operator",  regex : "[)]", next : "start"},
          ], 
          "equalsign" : [
              {token : "keyword.operator",  regex : "[=]", next : "constvalue"},
          ], 
      };
    this.normalizeRules();
};

Assembly6502HighlightRules.metaData = { fileTypes: [ 'asm' ],
      name: 'Assembly 6502',
      scopeName: 'source.assembly' };


oop.inherits(Assembly6502HighlightRules, TextHighlightRules);

exports.Assembly6502HighlightRules = Assembly6502HighlightRules;
});

ace.define("ace/mode/folding/coffee",["require","exports","module","ace/lib/oop","ace/mode/folding/fold_mode","ace/range"], function(require, exports, module) {
"use strict";

var oop = require("../../lib/oop");
var BaseFoldMode = require("./fold_mode").FoldMode;
var Range = require("../../range").Range;

var FoldMode = exports.FoldMode = function() {};
oop.inherits(FoldMode, BaseFoldMode);

(function() {

    this.getFoldWidgetRange = function(session, foldStyle, row) {
        var range = this.indentationBlock(session, row);
        if (range)
            return range;

        var re = /\S/;
        var line = session.getLine(row);
        var startLevel = line.search(re);
        if (startLevel == -1 || line[startLevel] != "#")
            return;

        var startColumn = line.length;
        var maxRow = session.getLength();
        var startRow = row;
        var endRow = row;

        while (++row < maxRow) {
            line = session.getLine(row);
            var level = line.search(re);

            if (level == -1)
                continue;

            if (line[level] != "#")
                break;

            endRow = row;
        }

        if (endRow > startRow) {
            var endColumn = session.getLine(endRow).length;
            return new Range(startRow, startColumn, endRow, endColumn);
        }
    };
    this.getFoldWidget = function(session, foldStyle, row) {
        var line = session.getLine(row);
        var indent = line.search(/\S/);
        var next = session.getLine(row + 1);
        var prev = session.getLine(row - 1);
        var prevIndent = prev.search(/\S/);
        var nextIndent = next.search(/\S/);

        if (indent == -1) {
            session.foldWidgets[row - 1] = prevIndent!= -1 && prevIndent < nextIndent ? "start" : "";
            return "";
        }
        if (prevIndent == -1) {
            if (indent == nextIndent && line[indent] == "#" && next[indent] == "#") {
                session.foldWidgets[row - 1] = "";
                session.foldWidgets[row + 1] = "";
                return "start";
            }
        } else if (prevIndent == indent && line[indent] == "#" && prev[indent] == "#") {
            if (session.getLine(row - 2).search(/\S/) == -1) {
                session.foldWidgets[row - 1] = "start";
                session.foldWidgets[row + 1] = "";
                return "";
            }
        }

        if (prevIndent!= -1 && prevIndent < indent)
            session.foldWidgets[row - 1] = "start";
        else
            session.foldWidgets[row - 1] = "";

        if (indent < nextIndent)
            return "start";
        else
            return "";
    };

}).call(FoldMode.prototype);

});

ace.define("ace/mode/assembly_6502",["require","exports","module","ace/lib/oop","ace/mode/text","ace/mode/assembly_6502_highlight_rules","ace/mode/folding/coffee"], function(require, exports, module) {
"use strict";

var oop = require("../lib/oop");
var TextMode = require("./text").Mode;
var Assembly6502HighlightRules = require("./assembly_6502_highlight_rules").Assembly6502HighlightRules;
var FoldMode = require("./folding/coffee").FoldMode;

var Mode = function() {
    this.HighlightRules = Assembly6502HighlightRules;
    this.foldingRules = new FoldMode();
    this.$behaviour = this.$defaultBehaviour;
};
oop.inherits(Mode, TextMode);

(function() {
    this.lineCommentStart = [";"];
    this.$id = "ace/mode/assembly_6502";
}).call(Mode.prototype);

exports.Mode = Mode;
});
(function() {
    ace.require(["ace/mode/assembly_6502"], function(m) {
        if (typeof module == "object" && typeof exports == "object" && module) {
            module.exports = m;
        }
    });
})();
            