/*
criticalCSS by @scottjehl. Run this on your CSS, get the styles that are applicable in the viewport (critical). The url arg should be any part of the URL of the stylesheets you'd like to parse. So, 'all.css' or '/css/' would both work.

Tip: https://css-tricks.com/authoring-critical-fold-css/

*/
function criticalCSS( url ){
	var sheets = document.styleSheets,
		maxTop = window.innerHeight,
		critical = [];

	function aboveFold( rule ){
		if( !rule.selectorText ){
			return false;
		}
		var selectors = rule.selectorText.split(","),
			criticalSelectors = [];
		if( selectors.length ){
			for( var l in selectors ){
				var elem;
				try {
					// webkit is really strict about standard selectors getting passed-in
					elem = document.querySelector( selectors[ l ] );
				}
				catch(e) {}
				if( elem && elem.offsetTop <= maxTop ){
					criticalSelectors.push( selectors[ l ] );
				}
			}
		}
		if( criticalSelectors.length ){
			return criticalSelectors.join(",") + rule.cssText.match( /\{.+/ );
		}
		else {
			return false;
		}
	}

	for( var i  in sheets ){
		var sheet = sheets[ i ],
			href = sheet.href,
			rules = sheet.cssRules,
			valid = true;

		if( url && href && href.indexOf( url ) > -1 ){
			for( var j in rules ){
				var media = rules[ j ].media,
					matchingRules = [];
				if( media ){
					var innerRules = rules[ j ].cssRules;
					for( var k in innerRules ){
						var critCSSText = aboveFold( innerRules[ k ] );
						if( critCSSText ){
							matchingRules.push( critCSSText );
						}
					}
					if( matchingRules.length ){
						matchingRules.unshift( "@media " + media.mediaText + "{" );
						matchingRules.push( "}" );
					}

				}
				else if( !media ){
					var critCSSText = aboveFold( rules[ j ] );
					if( critCSSText ){
						matchingRules.push( critCSSText );
					}
				}
				critical.push( matchingRules.join( "\n" ) );
			}

		}
	}
	return critical.join( "\n" );
}
