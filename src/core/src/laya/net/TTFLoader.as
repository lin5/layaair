package laya.net {
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.RunDriver;
	
	/**
	 * @private
	 */
	public class TTFLoader {
		
		public function TTFLoader() {
		
		}
		private static const _testString:String = "LayaTTFFont";
		public var fontName:String;
		public var complete:Handler;
		private var _fontTxt:String;
		private var _url:String;
		private var _div:*;
		private var _txtWidth:Number;
		
		public function load(fontPath:String):void {
			_url = fontPath;
			var tArr:Array = fontPath.split(".ttf")[0].split("/");
			fontName = tArr[tArr.length - 1];
			if (Browser.window.FontFace) {
				this._loadWithFontFace()
			}
			else {
				this._loadWithCSS();
			}
		}
		
		private function _complete():void {
			Laya.timer.clear(this, _complete);
			Laya.timer.clear(this, _checkComplete);
			if (_div && _div.parentNode) {
				
				_div.parentNode.removeChild(_div);
				_div = null;
			}
			if (complete) {
				complete.runWith(this);
				complete = null;
			}
		}
		
		private function _checkComplete():void {
			if (RunDriver.measureText(_testString, _fontTxt).width != _txtWidth) {
				_complete();
			}
		}
		
		private function _loadWithFontFace():void {
				
			var fontFace:* = new Browser.window.FontFace(fontName, "url('" + _url + "')");
			Browser.window.document.fonts.add(fontFace);
			var self:TTFLoader = this;
			fontFace.loaded.then((function():void {
					self._complete()
				}));
			//_createDiv();
			fontFace.load();
		
		}
		
		private function _createDiv():void {
			_div = Browser.createElement("div");
			_div.innerHTML = "laya";
			var _style:* = _div.style;
			_style.fontFamily = fontName;
			_style.position = "absolute";
			_style.left = "-100px";
			_style.top = "-100px";
			Browser.document.body.appendChild(_div);
		}
		
		private function _loadWithCSS():void {
			
			var fontStyle:* = Browser.createElement("style");
			fontStyle.type = "text/css";
			Browser.document.body.appendChild(fontStyle);
			fontStyle.textContent = "@font-face { font-family:'" + fontName + "'; src:url('" + _url + "');}";	
			_fontTxt = "40px " + fontName;
			_txtWidth = RunDriver.measureText(_testString, _fontTxt).width;
			
			var self:TTFLoader = this;
			fontStyle.onload = function():void {
				Laya.timer.once(10000, self, _complete);
			};
			Laya.timer.loop(20, this, _checkComplete);
			
			_createDiv();
		
		}
	
	}

}