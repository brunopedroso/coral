<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<script type="text/javascript">
//<![CDATA[
var version = {title: "TiddlyWiki", major: 2, minor: 3, revision: 0, date: new Date("Dec 4, 2007"), extensions: {}};
//]]>
</script>
<!--
TiddlyWiki created by Jeremy Ruston, (jeremy [at] osmosoft [dot] com)

Copyright (c) UnaMesa Association 2004-2007

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this
list of conditions and the following disclaimer in the documentation and/or other
materials provided with the distribution.

Neither the name of the UnaMesa Association nor the names of its contributors may be
used to endorse or promote products derived from this software without specific
prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
DAMAGE.
-->

<%@ page import="br.com.seatecnologia.coral.web.ContextoAplicacaoWeb"%>
<%@ page import="br.com.seatecnologia.coral.service.TiddlerService"%>
<%@ taglib uri="/WEB-INF/taglib/c.tld" prefix="c"%>
<%@ page isELIgnored="false"%>

<%
	TiddlerService service = (TiddlerService) ContextoAplicacaoWeb
			.getBean(request, "tiddlerService");

	String namespace = request.getParameter("namespace");
	if (namespace == null) {

		namespace = (String) session.getAttribute("namespace");
		if (namespace == null) {
			// default namespace
			namespace = "main";
		}
	}
	
	session.setAttribute("namespace", namespace);

	pageContext.setAttribute("tiddlers", service
			.loadNamespaceTiddlers(namespace));
			
	pageContext.setAttribute("namespaces", service
			.listNamespaces());
 					
 					
 %>


<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<!--PRE-HEAD-START-->
<!--{{{-->
<link rel='alternate' type='application/rss+xml' title='RSS' href='index.xml'/>
<!--}}}-->
<!--PRE-HEAD-END-->
<title>
TiddlyWiki - a reusable non-linear personal web notebook
</title>

<!-- Ajax -->
<script type='text/javascript' src='./dwr/interface/tiddlerService.js'></script>
<script type='text/javascript' src='./dwr/interface/uploadImportHelper.js'></script>
<script type='text/javascript' src='./dwr/engine.js'></script>

<style type="text/css">
#saveTest {display:none;}
#messageArea {display:none;}
#copyright {display:none;}
#storeArea {display:none;}
#storeArea div {padding:0.5em; margin:1em 0em 0em 0em; border-color:#fff #666 #444 #ddd; border-style:solid; border-width:2px; overflow:auto;}
#shadowArea {display:none;}
#javascriptWarning {width:100%; text-align:center; font-weight:bold; background-color:#dd1100; color:#fff; padding:1em 0em;}
</style>
<!--POST-HEAD-START-->
<!--POST-HEAD-END-->
</head>
<body onload="main();" onunload="if(window.checkUnsavedChanges) checkUnsavedChanges(); if(window.scrubNodes) scrubNodes(document.body);">
<!--PRE-BODY-START-->
<!--PRE-BODY-END-->
<div id="copyright">
Welcome to TiddlyWiki created by Jeremy Ruston, Copyright &copy; 2007 UnaMesa Association
</div>
<noscript>
	<div id="javascriptWarning">This page requires JavaScript to function properly.<br /><br />If you are using Microsoft Internet Explorer you may need to click on the yellow bar above and select 'Allow Blocked Content'. You must then click 'Yes' on the following security warning.</div>
</noscript>
<div id="saveTest"></div>
<div id="backstageCloak"></div>
<div id="backstageButton"></div>
<div id="backstageArea"><div id="backstageToolbar"></div></div>
<div id="backstage">
	<div id="backstagePanel"></div>
</div>
<div id="contentWrapper"></div>
<div id="contentStash"></div>
<div id="shadowArea">
<div title="MarkupPreHead">
<pre>&lt;!--{{{--&gt;
&lt;link rel='alternate' type='application/rss+xml' title='RSS' href='index.xml'/&gt;
&lt;!--}}}--&gt;</pre>
</div>
<div title="ColorPalette">
<pre>Background: #fff
Foreground: #000
PrimaryPale: #8cf
PrimaryLight: #18f
PrimaryMid: #04b
PrimaryDark: #014
SecondaryPale: #ffc
SecondaryLight: #fe8
SecondaryMid: #db4
SecondaryDark: #841
TertiaryPale: #eee
TertiaryLight: #ccc
TertiaryMid: #999
TertiaryDark: #666
Error: #f88</pre>
</div>
<div title="StyleSheetColors">
<pre>/*{{{*/
body {background:[[ColorPalette::Background]]; color:[[ColorPalette::Foreground]];}

a {color:[[ColorPalette::PrimaryMid]];}
a:hover {background-color:[[ColorPalette::PrimaryMid]]; color:[[ColorPalette::Background]];}
a img {border:0;}

h1,h2,h3,h4,h5,h6 {color:[[ColorPalette::SecondaryDark]]; background:transparent;}
h1 {border-bottom:2px solid [[ColorPalette::TertiaryLight]];}
h2,h3 {border-bottom:1px solid [[ColorPalette::TertiaryLight]];}

.button {color:[[ColorPalette::PrimaryDark]]; border:1px solid [[ColorPalette::Background]];}
.button:hover {color:[[ColorPalette::PrimaryDark]]; background:[[ColorPalette::SecondaryLight]]; border-color:[[ColorPalette::SecondaryMid]];}
.button:active {color:[[ColorPalette::Background]]; background:[[ColorPalette::SecondaryMid]]; border:1px solid [[ColorPalette::SecondaryDark]];}

.header {background:[[ColorPalette::PrimaryMid]];}
.headerShadow {color:[[ColorPalette::Foreground]];}
.headerShadow a {font-weight:normal; color:[[ColorPalette::Foreground]];}
.headerForeground {color:[[ColorPalette::Background]];}
.headerForeground a {font-weight:normal; color:[[ColorPalette::PrimaryPale]];}

.tabSelected{color:[[ColorPalette::PrimaryDark]];
	background:[[ColorPalette::TertiaryPale]];
	border-left:1px solid [[ColorPalette::TertiaryLight]];
	border-top:1px solid [[ColorPalette::TertiaryLight]];
	border-right:1px solid [[ColorPalette::TertiaryLight]];
}
.tabUnselected {color:[[ColorPalette::Background]]; background:[[ColorPalette::TertiaryMid]];}
.tabContents {color:[[ColorPalette::PrimaryDark]]; background:[[ColorPalette::TertiaryPale]]; border:1px solid [[ColorPalette::TertiaryLight]];}
.tabContents .button {border:0;}

#sidebar {}
#sidebarOptions input {border:1px solid [[ColorPalette::PrimaryMid]];}
#sidebarOptions .sliderPanel {background:[[ColorPalette::PrimaryPale]];}
#sidebarOptions .sliderPanel a {border:none;color:[[ColorPalette::PrimaryMid]];}
#sidebarOptions .sliderPanel a:hover {color:[[ColorPalette::Background]]; background:[[ColorPalette::PrimaryMid]];}
#sidebarOptions .sliderPanel a:active {color:[[ColorPalette::PrimaryMid]]; background:[[ColorPalette::Background]];}

.wizard {background:[[ColorPalette::PrimaryPale]]; border:1px solid [[ColorPalette::PrimaryMid]];}
.wizard h1 {color:[[ColorPalette::PrimaryDark]]; border:none;}
.wizard h2 {color:[[ColorPalette::Foreground]]; border:none;}
.wizardStep {background:[[ColorPalette::Background]]; color:[[ColorPalette::Foreground]];
	border:1px solid [[ColorPalette::PrimaryMid]];}
.wizardStep.wizardStepDone {background:[[ColorPalette::TertiaryLight]];}
.wizardFooter {background:[[ColorPalette::PrimaryPale]];}
.wizardFooter .status {background:[[ColorPalette::PrimaryDark]]; color:[[ColorPalette::Background]];}
.wizard .button {color:[[ColorPalette::Foreground]]; background:[[ColorPalette::SecondaryLight]]; border: 1px solid;
	border-color:[[ColorPalette::SecondaryPale]] [[ColorPalette::SecondaryDark]] [[ColorPalette::SecondaryDark]] [[ColorPalette::SecondaryPale]];}
.wizard .button:hover {color:[[ColorPalette::Foreground]]; background:[[ColorPalette::Background]];}
.wizard .button:active {color:[[ColorPalette::Background]]; background:[[ColorPalette::Foreground]]; border: 1px solid;
	border-color:[[ColorPalette::PrimaryDark]] [[ColorPalette::PrimaryPale]] [[ColorPalette::PrimaryPale]] [[ColorPalette::PrimaryDark]];}

#messageArea {border:1px solid [[ColorPalette::SecondaryMid]]; background:[[ColorPalette::SecondaryLight]]; color:[[ColorPalette::Foreground]];}
#messageArea .button {color:[[ColorPalette::PrimaryMid]]; background:[[ColorPalette::SecondaryPale]]; border:none;}

.popupTiddler {background:[[ColorPalette::TertiaryPale]]; border:2px solid [[ColorPalette::TertiaryMid]];}

.popup {background:[[ColorPalette::TertiaryPale]]; color:[[ColorPalette::TertiaryDark]]; border-left:1px solid [[ColorPalette::TertiaryMid]]; border-top:1px solid [[ColorPalette::TertiaryMid]]; border-right:2px solid [[ColorPalette::TertiaryDark]]; border-bottom:2px solid [[ColorPalette::TertiaryDark]];}
.popup hr {color:[[ColorPalette::PrimaryDark]]; background:[[ColorPalette::PrimaryDark]]; border-bottom:1px;}
.popup li.disabled {color:[[ColorPalette::TertiaryMid]];}
.popup li a, .popup li a:visited {color:[[ColorPalette::Foreground]]; border: none;}
.popup li a:hover {background:[[ColorPalette::SecondaryLight]]; color:[[ColorPalette::Foreground]]; border: none;}
.popup li a:active {background:[[ColorPalette::SecondaryPale]]; color:[[ColorPalette::Foreground]]; border: none;}
.popupHighlight {background:[[ColorPalette::Background]]; color:[[ColorPalette::Foreground]];}
.listBreak div {border-bottom:1px solid [[ColorPalette::TertiaryDark]];}

.tiddler .defaultCommand {font-weight:bold;}

.shadow .title {color:[[ColorPalette::TertiaryDark]];}

.title {color:[[ColorPalette::SecondaryDark]];}
.subtitle {color:[[ColorPalette::TertiaryDark]];}

.toolbar {color:[[ColorPalette::PrimaryMid]];}
.toolbar a {color:[[ColorPalette::TertiaryLight]];}
.selected .toolbar a {color:[[ColorPalette::TertiaryMid]];}
.selected .toolbar a:hover {color:[[ColorPalette::Foreground]];}

.tagging, .tagged {border:1px solid [[ColorPalette::TertiaryPale]]; background-color:[[ColorPalette::TertiaryPale]];}
.selected .tagging, .selected .tagged {background-color:[[ColorPalette::TertiaryLight]]; border:1px solid [[ColorPalette::TertiaryMid]];}
.tagging .listTitle, .tagged .listTitle {color:[[ColorPalette::PrimaryDark]];}
.tagging .button, .tagged .button {border:none;}

.footer {color:[[ColorPalette::TertiaryLight]];}
.selected .footer {color:[[ColorPalette::TertiaryMid]];}

.sparkline {background:[[ColorPalette::PrimaryPale]]; border:0;}
.sparktick {background:[[ColorPalette::PrimaryDark]];}

.error, .errorButton {color:[[ColorPalette::Foreground]]; background:[[ColorPalette::Error]];}
.warning {color:[[ColorPalette::Foreground]]; background:[[ColorPalette::SecondaryPale]];}
.lowlight {background:[[ColorPalette::TertiaryLight]];}

.zoomer {background:none; color:[[ColorPalette::TertiaryMid]]; border:3px solid [[ColorPalette::TertiaryMid]];}

.imageLink, #displayArea .imageLink {background:transparent;}

.annotation {background:[[ColorPalette::SecondaryLight]]; color:[[ColorPalette::Foreground]]; border:2px solid [[ColorPalette::SecondaryMid]];}

.viewer .listTitle {list-style-type:none; margin-left:-2em;}
.viewer .button {border:1px solid [[ColorPalette::SecondaryMid]];}
.viewer blockquote {border-left:3px solid [[ColorPalette::TertiaryDark]];}

.viewer table, table.twtable {border:2px solid [[ColorPalette::TertiaryDark]];}
.viewer th, .viewer thead td, .twtable th, .twtable thead td {background:[[ColorPalette::SecondaryMid]]; border:1px solid [[ColorPalette::TertiaryDark]]; color:[[ColorPalette::Background]];}
.viewer td, .viewer tr, .twtable td, .twtable tr {border:1px solid [[ColorPalette::TertiaryDark]];}

.viewer pre {border:1px solid [[ColorPalette::SecondaryLight]]; background:[[ColorPalette::SecondaryPale]];}
.viewer code {color:[[ColorPalette::SecondaryDark]];}
.viewer hr {border:0; border-top:dashed 1px [[ColorPalette::TertiaryDark]]; color:[[ColorPalette::TertiaryDark]];}

.highlight, .marked {background:[[ColorPalette::SecondaryLight]];}

.editor input {border:1px solid [[ColorPalette::PrimaryMid]];}
.editor textarea {border:1px solid [[ColorPalette::PrimaryMid]]; width:100%;}
.editorFooter {color:[[ColorPalette::TertiaryMid]];}

#backstageArea {background:[[ColorPalette::Foreground]]; color:[[ColorPalette::TertiaryMid]];}
#backstageArea a {background:[[ColorPalette::Foreground]]; color:[[ColorPalette::Background]]; border:none;}
#backstageArea a:hover {background:[[ColorPalette::SecondaryLight]]; color:[[ColorPalette::Foreground]]; }
#backstageArea a.backstageSelTab {background:[[ColorPalette::Background]]; color:[[ColorPalette::Foreground]];}
#backstageButton a {background:none; color:[[ColorPalette::Background]]; border:none;}
#backstageButton a:hover {background:[[ColorPalette::Foreground]]; color:[[ColorPalette::Background]]; border:none;}
#backstagePanel {background:[[ColorPalette::Background]]; border-color: [[ColorPalette::Background]] [[ColorPalette::TertiaryDark]] [[ColorPalette::TertiaryDark]] [[ColorPalette::TertiaryDark]];}
.backstagePanelFooter .button {border:none; color:[[ColorPalette::Background]];}
.backstagePanelFooter .button:hover {color:[[ColorPalette::Foreground]];}
#backstageCloak {background:[[ColorPalette::Foreground]]; opacity:0.6; filter:'alpha(opacity:60)';}
/*}}}*/</pre>
</div>
<div title="StyleSheetLayout">
<pre>/*{{{*/
* html .tiddler {height:1%;}

body {font-size:.75em; font-family:arial,helvetica; margin:0; padding:0;}

h1,h2,h3,h4,h5,h6 {font-weight:bold; text-decoration:none;}
h1,h2,h3 {padding-bottom:1px; margin-top:1.2em;margin-bottom:0.3em;}
h4,h5,h6 {margin-top:1em;}
h1 {font-size:1.35em;}
h2 {font-size:1.25em;}
h3 {font-size:1.1em;}
h4 {font-size:1em;}
h5 {font-size:.9em;}

hr {height:1px;}

a {text-decoration:none;}

dt {font-weight:bold;}

ol {list-style-type:decimal;}
ol ol {list-style-type:lower-alpha;}
ol ol ol {list-style-type:lower-roman;}
ol ol ol ol {list-style-type:decimal;}
ol ol ol ol ol {list-style-type:lower-alpha;}
ol ol ol ol ol ol {list-style-type:lower-roman;}
ol ol ol ol ol ol ol {list-style-type:decimal;}

.txtOptionInput {width:11em;}

#contentWrapper .chkOptionInput {border:0;}

.externalLink {text-decoration:underline;}

.indent {margin-left:3em;}
.outdent {margin-left:3em; text-indent:-3em;}
code.escaped {white-space:nowrap;}

.tiddlyLinkExisting {font-weight:bold;}
.tiddlyLinkNonExisting {font-style:italic;}

/* the 'a' is required for IE, otherwise it renders the whole tiddler in bold */
a.tiddlyLinkNonExisting.shadow {font-weight:bold;}

#mainMenu .tiddlyLinkExisting,
	#mainMenu .tiddlyLinkNonExisting,
	#sidebarTabs .tiddlyLinkNonExisting {font-weight:normal; font-style:normal;}
#sidebarTabs .tiddlyLinkExisting {font-weight:bold; font-style:normal;}

.header {position:relative;}
.header a:hover {background:transparent;}
.headerShadow {position:relative; padding:4.5em 0em 1em 1em; left:-1px; top:-1px;}
.headerForeground {position:absolute; padding:4.5em 0em 1em 1em; left:0px; top:0px;}

.siteTitle {font-size:3em;}
.siteSubtitle {font-size:1.2em;}

#mainMenu {position:absolute; left:0; width:10em; text-align:right; line-height:1.6em; padding:1.5em 0.5em 0.5em 0.5em; font-size:1.1em;}

#sidebar {position:absolute; right:3px; width:16em; font-size:.9em;}
#sidebarOptions {padding-top:0.3em;}
#sidebarOptions a {margin:0em 0.2em; padding:0.2em 0.3em; display:block;}
#sidebarOptions input {margin:0.4em 0.5em;}
#sidebarOptions .sliderPanel {margin-left:1em; padding:0.5em; font-size:.85em;}
#sidebarOptions .sliderPanel a {font-weight:bold; display:inline; padding:0;}
#sidebarOptions .sliderPanel input {margin:0 0 .3em 0;}
#sidebarTabs .tabContents {width:15em; overflow:hidden;}

.wizard {padding:0.1em 1em 0em 2em;}
.wizard h1 {font-size:2em; font-weight:bold; background:none; padding:0em 0em 0em 0em; margin:0.4em 0em 0.2em 0em;}
.wizard h2 {font-size:1.2em; font-weight:bold; background:none; padding:0em 0em 0em 0em; margin:0.4em 0em 0.2em 0em;}
.wizardStep {padding:1em 1em 1em 1em;}
.wizard .button {margin:0.5em 0em 0em 0em; font-size:1.2em;}
.wizardFooter {padding:0.8em 0.4em 0.8em 0em;}
.wizardFooter .status {padding:0em 0.4em 0em 0.4em; margin-left:1em;}
.wizard .button {padding:0.1em 0.2em 0.1em 0.2em;}

#messageArea {position:fixed; top:2em; right:0em; margin:0.5em; padding:0.5em; z-index:2000; _position:absolute;}
.messageToolbar {display:block; text-align:right; padding:0.2em 0.2em 0.2em 0.2em;}
#messageArea a {text-decoration:underline;}

.tiddlerPopupButton {padding:0.2em 0.2em 0.2em 0.2em;}
.popupTiddler {position: absolute; z-index:300; padding:1em 1em 1em 1em; margin:0;}

.popup {position:absolute; z-index:300; font-size:.9em; padding:0; list-style:none; margin:0;}
.popup .popupMessage {padding:0.4em;}
.popup hr {display:block; height:1px; width:auto; padding:0; margin:0.2em 0em;}
.popup li.disabled {padding:0.4em;}
.popup li a {display:block; padding:0.4em; font-weight:normal; cursor:pointer;}
.listBreak {font-size:1px; line-height:1px;}
.listBreak div {margin:2px 0;}

.tabset {padding:1em 0em 0em 0.5em;}
.tab {margin:0em 0em 0em 0.25em; padding:2px;}
.tabContents {padding:0.5em;}
.tabContents ul, .tabContents ol {margin:0; padding:0;}
.txtMainTab .tabContents li {list-style:none;}
.tabContents li.listLink { margin-left:.75em;}

#contentWrapper {display:block;}
#splashScreen {display:none;}

#displayArea {margin:1em 17em 0em 14em;}

.toolbar {text-align:right; font-size:.9em;}

.tiddler {padding:1em 1em 0em 1em;}

.missing .viewer,.missing .title {font-style:italic;}

.title {font-size:1.6em; font-weight:bold;}

.missing .subtitle {display:none;}
.subtitle {font-size:1.1em;}

.tiddler .button {padding:0.2em 0.4em;}

.tagging {margin:0.5em 0.5em 0.5em 0; float:left; display:none;}
.isTag .tagging {display:block;}
.tagged {margin:0.5em; float:right;}
.tagging, .tagged {font-size:0.9em; padding:0.25em;}
.tagging ul, .tagged ul {list-style:none; margin:0.25em; padding:0;}
.tagClear {clear:both;}

.footer {font-size:.9em;}
.footer li {display:inline;}

.annotation {padding:0.5em; margin:0.5em;}

* html .viewer pre {width:99%; padding:0 0 1em 0;}
.viewer {line-height:1.4em; padding-top:0.5em;}
.viewer .button {margin:0em 0.25em; padding:0em 0.25em;}
.viewer blockquote {line-height:1.5em; padding-left:0.8em;margin-left:2.5em;}
.viewer ul, .viewer ol {margin-left:0.5em; padding-left:1.5em;}

.viewer table, table.twtable {border-collapse:collapse; margin:0.8em 1.0em;}
.viewer th, .viewer td, .viewer tr,.viewer caption,.twtable th, .twtable td, .twtable tr,.twtable caption {padding:3px;}
table.listView {font-size:0.85em; margin:0.8em 1.0em;}
table.listView th, table.listView td, table.listView tr {padding:0px 3px 0px 3px;}

.viewer pre {padding:0.5em; margin-left:0.5em; font-size:1.2em; line-height:1.4em; overflow:auto;}
.viewer code {font-size:1.2em; line-height:1.4em;}

.editor {font-size:1.1em;}
.editor input, .editor textarea {display:block; width:100%; font:inherit;}
.editorFooter {padding:0.25em 0em; font-size:.9em;}
.editorFooter .button {padding-top:0px; padding-bottom:0px;}

.fieldsetFix {border:0; padding:0; margin:1px 0px 1px 0px;}

.sparkline {line-height:1em;}
.sparktick {outline:0;}

.zoomer {font-size:1.1em; position:absolute; overflow:hidden;}
.zoomer div {padding:1em;}

* html #backstage {width:99%;}
* html #backstageArea {width:99%;}
#backstageArea {display:none; position:relative; overflow: hidden; z-index:150; padding:0.3em 0.5em 0.3em 0.5em;}
#backstageToolbar {position:relative;}
#backstageArea a {font-weight:bold; margin-left:0.5em; padding:0.3em 0.5em 0.3em 0.5em;}
#backstageButton {display:none; position:absolute; z-index:175; top:0em; right:0em;}
#backstageButton a {padding:0.1em 0.4em 0.1em 0.4em; margin:0.1em 0.1em 0.1em 0.1em;}
#backstage {position:relative; width:100%; z-index:50;}
#backstagePanel {display:none; z-index:100; position:absolute; margin:0em 3em 0em 3em; padding:1em 1em 1em 1em;}
.backstagePanelFooter {padding-top:0.2em; float:right;}
.backstagePanelFooter a {padding:0.2em 0.4em 0.2em 0.4em;}
#backstageCloak {display:none; z-index:20; position:absolute; width:100%; height:100px;}

.whenBackstage {display:none;}
.backstageVisible .whenBackstage {display:block;}
/*}}}*/</pre>
</div>
<div title="StyleSheetLocale">
<pre>/***
StyleSheet for use when a translation requires any css style changes.
This StyleSheet can be used directly by languages such as Chinese, Japanese and Korean which need larger font sizes.
***/
/*{{{*/
body {font-size:0.8em;}
#sidebarOptions {font-size:1.05em;}
#sidebarOptions a {font-style:normal;}
#sidebarOptions .sliderPanel {font-size:0.95em;}
.subtitle {font-size:0.8em;}
.viewer table.listView {font-size:0.95em;}
/*}}}*/</pre>
</div>
<div title="StyleSheetPrint">
<pre>/*{{{*/
@media print {
#mainMenu, #sidebar, #messageArea, .toolbar, #backstageButton, #backstageArea {display: none ! important;}
#displayArea {margin: 1em 1em 0em 1em;}
/* Fixes a feature in Firefox 1.5.0.2 where print preview displays the noscript content */
noscript {display:none;}
}
/*}}}*/</pre>
</div>
<div title="PageTemplate">
<pre>&lt;!--{{{--&gt;
&lt;div class='header' macro='gradient vert [[ColorPalette::PrimaryLight]] [[ColorPalette::PrimaryMid]]'&gt;
&lt;div class='headerShadow'&gt;
&lt;span class='siteTitle' refresh='content' tiddler='SiteTitle'&gt;&lt;/span&gt;&amp;nbsp;
&lt;span class='siteSubtitle' refresh='content' tiddler='SiteSubtitle'&gt;&lt;/span&gt;
&lt;/div&gt;
&lt;div class='headerForeground'&gt;
&lt;span class='siteTitle' refresh='content' tiddler='SiteTitle'&gt;&lt;/span&gt;&amp;nbsp;
&lt;span class='siteSubtitle' refresh='content' tiddler='SiteSubtitle'&gt;&lt;/span&gt;
&lt;/div&gt;
&lt;/div&gt;
&lt;div id='mainMenu' refresh='content' tiddler='MainMenu'&gt;&lt;/div&gt;
&lt;div id='sidebar'&gt;
&lt;div id='sidebarOptions' refresh='content' tiddler='SideBarOptions'&gt;&lt;/div&gt;
&lt;div id='sidebarTabs' refresh='content' force='true' tiddler='SideBarTabs'&gt;&lt;/div&gt;
&lt;/div&gt;
&lt;div id='displayArea'&gt;
&lt;div id='messageArea'&gt;&lt;/div&gt;
&lt;div id='tiddlerDisplay'&gt;&lt;/div&gt;
&lt;/div&gt;
&lt;!--}}}--&gt;</pre>
</div>
<div title="ViewTemplate">
<pre>&lt;!--{{{--&gt;
&lt;div class='toolbar' macro='toolbar closeTiddler closeOthers +editTiddler &gt; fields syncing permalink references jump'&gt;&lt;/div&gt;
&lt;div class='title' macro='view title'&gt;&lt;/div&gt;
&lt;div class='subtitle'&gt;&lt;span macro='view modifier link'&gt;&lt;/span&gt;, &lt;span macro='view modified date'&gt;&lt;/span&gt; (&lt;span macro='message views.wikified.createdPrompt'&gt;&lt;/span&gt; &lt;span macro='view created date'&gt;&lt;/span&gt;)&lt;/div&gt;
&lt;div class='tagging' macro='tagging'&gt;&lt;/div&gt;
&lt;div class='tagged' macro='tags'&gt;&lt;/div&gt;
&lt;div class='viewer' macro='view text wikified'&gt;&lt;/div&gt;
&lt;div class='tagClear'&gt;&lt;/div&gt;
&lt;!--}}}--&gt;</pre>
</div>
<div title="EditTemplate">
<pre>&lt;!--{{{--&gt;
&lt;div class='toolbar' macro='toolbar +saveTiddler -cancelTiddler deleteTiddler'&gt;&lt;/div&gt;
&lt;div class='title' macro='view title'&gt;&lt;/div&gt;
&lt;div class='editor' macro='edit title'&gt;&lt;/div&gt;
&lt;div macro='annotations'&gt;&lt;/div&gt;
&lt;div class='editor' macro='edit text'&gt;&lt;/div&gt;
&lt;div class='editor' macro='edit tags'&gt;&lt;/div&gt;&lt;div class='editorFooter'&gt;&lt;span macro='message views.editor.tagPrompt'&gt;&lt;/span&gt;&lt;span macro='tagChooser'&gt;&lt;/span&gt;&lt;/div&gt;
&lt;!--}}}--&gt;</pre>
</div>
<div title="GettingStarted">
<pre>To get started with this blank TiddlyWiki, you'll need to modify the following tiddlers:
* SiteTitle &amp; SiteSubtitle: The title and subtitle of the site, as shown above (after saving, they will also appear in the browser title bar)
* MainMenu: The menu (usually on the left)
* DefaultTiddlers: Contains the names of the tiddlers that you want to appear when the TiddlyWiki is opened
You'll also need to enter your username for signing your edits: &lt;&lt;option txtUserName&gt;&gt;</pre>
</div>
<div title="OptionsPanel">
<pre>These InterfaceOptions for customising TiddlyWiki are saved in your browser

Your username for signing your edits. Write it as a WikiWord (eg JoeBloggs)

&lt;&lt;option txtUserName&gt;&gt;
&lt;&lt;option chkSaveBackups&gt;&gt; SaveBackups
&lt;&lt;option chkAutoSave&gt;&gt; AutoSave
&lt;&lt;option chkRegExpSearch&gt;&gt; RegExpSearch
&lt;&lt;option chkCaseSensitiveSearch&gt;&gt; CaseSensitiveSearch
&lt;&lt;option chkAnimate&gt;&gt; EnableAnimations

----
Also see AdvancedOptions</pre>
</div>
<div title="ImportTiddlers">
<pre>&lt;&lt;importTiddlers&gt;&gt;</pre>
</div>
</div>
<!--POST-SHADOWAREA-->
<div id="storeArea">
<div title="LegacyStrikeThroughPlugin" modifier="MartinBudden" created="200607210000" tags="systemConfig">
<pre>/***
|''Name:''|LegacyStrikeThroughPlugin|
|''Description:''|Support for legacy (pre 2.1) strike through formatting|
|''Version:''|1.0.2|
|''Date:''|Jul 21, 2006|
|''Source:''|http://www.tiddlywiki.com/#LegacyStrikeThroughPlugin|
|''Author:''|MartinBudden (mjbudden (at) gmail (dot) com)|
|''License:''|[[BSD open source license]]|
|''CoreVersion:''|2.1.0|
***/

//{{{
// Ensure that the LegacyStrikeThrough Plugin is only installed once.
if(!version.extensions.LegacyStrikeThroughPlugin) {
version.extensions.LegacyStrikeThroughPlugin = {installed:true};

config.formatters.push(
{
	name: &quot;legacyStrikeByChar&quot;,
	match: &quot;==&quot;,
	termRegExp: /(==)/mg,
	element: &quot;strike&quot;,
	handler: config.formatterHelpers.createElementAndWikify
});

} //# end of &quot;install only once&quot;
//}}}</pre>
</div>
<div title="SparklinePlugin" created="200710125059" tags="systemConfig excludeLists excludeSearch">
<pre>/***
|''Name:''|SparklinePlugin|
|''Description:''|Sparklines macro|
***/
//{{{
if(!version.extensions.SparklinePlugin) {
version.extensions.SparklinePlugin = {installed:true};

//--
//-- Sparklines
//--

config.macros.sparkline = {};
config.macros.sparkline.handler = function(place,macroName,params)
{
	var data = [];
	var min = 0;
	var max = 0;
	var v;
	for(var t=0; t&lt;params.length; t++) {
		v = parseInt(params[t]);
		if(v &lt; min)
			min = v;
		if(v &gt; max)
			max = v;
		data.push(v);
	}
	if(data.length &lt; 1)
		return;
	var box = createTiddlyElement(place,&quot;span&quot;,null,&quot;sparkline&quot;,String.fromCharCode(160));
	box.title = data.join(&quot;,&quot;);
	var w = box.offsetWidth;
	var h = box.offsetHeight;
	box.style.paddingRight = (data.length * 2 - w) + &quot;px&quot;;
	box.style.position = &quot;relative&quot;;
	for(var d=0; d&lt;data.length; d++) {
		var tick = document.createElement(&quot;img&quot;);
		tick.border = 0;
		tick.className = &quot;sparktick&quot;;
		tick.style.position = &quot;absolute&quot;;
		tick.src = &quot;data:image/gif,GIF89a%01%00%01%00%91%FF%00%FF%FF%FF%00%00%00%C0%C0%C0%00%00%00!%F9%04%01%00%00%02%00%2C%00%00%00%00%01%00%01%00%40%02%02T%01%00%3B&quot;;
		tick.style.left = d*2 + &quot;px&quot;;
		tick.style.width = &quot;2px&quot;;
		v = Math.floor(((data[d] - min)/(max-min)) * h);
		tick.style.top = (h-v) + &quot;px&quot;;
		tick.style.height = v + &quot;px&quot;;
		box.appendChild(tick);
	}
};


}
//}}}</pre>
</div>
<div title="CryptoFunctionsPlugin" created="200710115934" tags="systemConfig excludeLists excludeSearch">
<pre>/***
|''Name:''|CryptoFunctionsPlugin|
|''Description:''|Support for cryptographic functions|
***/
//{{{
if(!version.extensions.CryptoFunctionsPlugin) {
version.extensions.CryptoFunctionsPlugin = {installed:true};

//--
//-- Crypto functions and associated conversion routines
//--

// Crypto &quot;namespace&quot;
function Crypto() {}

// Convert a string to an array of big-endian 32-bit words
Crypto.strToBe32s = function(str)
{
	var be = Array();
	var len = Math.floor(str.length/4);
	var i, j;
	for(i=0, j=0; i&lt;len; i++, j+=4) {
		be[i] = ((str.charCodeAt(j)&amp;0xff) &lt;&lt; 24)|((str.charCodeAt(j+1)&amp;0xff) &lt;&lt; 16)|((str.charCodeAt(j+2)&amp;0xff) &lt;&lt; 8)|(str.charCodeAt(j+3)&amp;0xff);
	}
	while (j&lt;str.length) {
		be[j&gt;&gt;2] |= (str.charCodeAt(j)&amp;0xff)&lt;&lt;(24-(j*8)%32);
		j++;
	}
	return be;
};

// Convert an array of big-endian 32-bit words to a string
Crypto.be32sToStr = function(be)
{
	var str = &quot;&quot;;
	for(var i=0;i&lt;be.length*32;i+=8)
		str += String.fromCharCode((be[i&gt;&gt;5]&gt;&gt;&gt;(24-i%32)) &amp; 0xff);
	return str;
};

// Convert an array of big-endian 32-bit words to a hex string
Crypto.be32sToHex = function(be)
{
	var hex = &quot;0123456789ABCDEF&quot;;
	var str = &quot;&quot;;
	for(var i=0;i&lt;be.length*4;i++)
		str += hex.charAt((be[i&gt;&gt;2]&gt;&gt;((3-i%4)*8+4))&amp;0xF) + hex.charAt((be[i&gt;&gt;2]&gt;&gt;((3-i%4)*8))&amp;0xF);
	return str;
};

// Return, in hex, the SHA-1 hash of a string
Crypto.hexSha1Str = function(str)
{
	return Crypto.be32sToHex(Crypto.sha1Str(str));
};

// Return the SHA-1 hash of a string
Crypto.sha1Str = function(str)
{
	return Crypto.sha1(Crypto.strToBe32s(str),str.length);
};

// Calculate the SHA-1 hash of an array of blen bytes of big-endian 32-bit words
Crypto.sha1 = function(x,blen)
{
	// Add 32-bit integers, wrapping at 32 bits
	add32 = function(a,b)
	{
		var lsw = (a&amp;0xFFFF)+(b&amp;0xFFFF);
		var msw = (a&gt;&gt;16)+(b&gt;&gt;16)+(lsw&gt;&gt;16);
		return (msw&lt;&lt;16)|(lsw&amp;0xFFFF);
	};
	// Add five 32-bit integers, wrapping at 32 bits
	add32x5 = function(a,b,c,d,e)
	{
		var lsw = (a&amp;0xFFFF)+(b&amp;0xFFFF)+(c&amp;0xFFFF)+(d&amp;0xFFFF)+(e&amp;0xFFFF);
		var msw = (a&gt;&gt;16)+(b&gt;&gt;16)+(c&gt;&gt;16)+(d&gt;&gt;16)+(e&gt;&gt;16)+(lsw&gt;&gt;16);
		return (msw&lt;&lt;16)|(lsw&amp;0xFFFF);
	};
	// Bitwise rotate left a 32-bit integer by 1 bit
	rol32 = function(n)
	{
		return (n&gt;&gt;&gt;31)|(n&lt;&lt;1);
	};

	var len = blen*8;
	// Append padding so length in bits is 448 mod 512
	x[len&gt;&gt;5] |= 0x80 &lt;&lt; (24-len%32);
	// Append length
	x[((len+64&gt;&gt;9)&lt;&lt;4)+15] = len;
	var w = Array(80);

	var k1 = 0x5A827999;
	var k2 = 0x6ED9EBA1;
	var k3 = 0x8F1BBCDC;
	var k4 = 0xCA62C1D6;

	var h0 = 0x67452301;
	var h1 = 0xEFCDAB89;
	var h2 = 0x98BADCFE;
	var h3 = 0x10325476;
	var h4 = 0xC3D2E1F0;

	for(var i=0;i&lt;x.length;i+=16) {
		var j,t;
		var a = h0;
		var b = h1;
		var c = h2;
		var d = h3;
		var e = h4;
		for(j = 0;j&lt;16;j++) {
			w[j] = x[i+j];
			t = add32x5(e,(a&gt;&gt;&gt;27)|(a&lt;&lt;5),d^(b&amp;(c^d)),w[j],k1);
			e=d; d=c; c=(b&gt;&gt;&gt;2)|(b&lt;&lt;30); b=a; a = t;
		}
		for(j=16;j&lt;20;j++) {
			w[j] = rol32(w[j-3]^w[j-8]^w[j-14]^w[j-16]);
			t = add32x5(e,(a&gt;&gt;&gt;27)|(a&lt;&lt;5),d^(b&amp;(c^d)),w[j],k1);
			e=d; d=c; c=(b&gt;&gt;&gt;2)|(b&lt;&lt;30); b=a; a = t;
		}
		for(j=20;j&lt;40;j++) {
			w[j] = rol32(w[j-3]^w[j-8]^w[j-14]^w[j-16]);
			t = add32x5(e,(a&gt;&gt;&gt;27)|(a&lt;&lt;5),b^c^d,w[j],k2);
			e=d; d=c; c=(b&gt;&gt;&gt;2)|(b&lt;&lt;30); b=a; a = t;
		}
		for(j=40;j&lt;60;j++) {
			w[j] = rol32(w[j-3]^w[j-8]^w[j-14]^w[j-16]);
			t = add32x5(e,(a&gt;&gt;&gt;27)|(a&lt;&lt;5),(b&amp;c)|(d&amp;(b|c)),w[j],k3);
			e=d; d=c; c=(b&gt;&gt;&gt;2)|(b&lt;&lt;30); b=a; a = t;
		}
		for(j=60;j&lt;80;j++) {
			w[j] = rol32(w[j-3]^w[j-8]^w[j-14]^w[j-16]);
			t = add32x5(e,(a&gt;&gt;&gt;27)|(a&lt;&lt;5),b^c^d,w[j],k4);
			e=d; d=c; c=(b&gt;&gt;&gt;2)|(b&lt;&lt;30); b=a; a = t;
		}

		h0 = add32(h0,a);
		h1 = add32(h1,b);
		h2 = add32(h2,c);
		h3 = add32(h3,d);
		h4 = add32(h4,e);
	}
	return Array(h0,h1,h2,h3,h4);
};


}
//}}}</pre>
</div>
<div title="DeprecatedFunctionsPlugin" created="200710125059" tags="systemConfig excludeLists excludeSearch">
<pre>/***
|''Name:''|DeprecatedFunctionsPlugin|
|''Description:''|Support for deprecated functions removed from core|
***/
//{{{
if(!version.extensions.DeprecatedFunctionsPlugin) {
version.extensions.DeprecatedFunctionsPlugin = {installed:true};

//--
//-- Deprecated code
//--

// @Deprecated: Use createElementAndWikify and this.termRegExp instead
config.formatterHelpers.charFormatHelper = function(w)
{
	w.subWikify(createTiddlyElement(w.output,this.element),this.terminator);
};

// @Deprecated: Use enclosedTextHelper and this.lookaheadRegExp instead
config.formatterHelpers.monospacedByLineHelper = function(w)
{
	var lookaheadRegExp = new RegExp(this.lookahead,&quot;mg&quot;);
	lookaheadRegExp.lastIndex = w.matchStart;
	var lookaheadMatch = lookaheadRegExp.exec(w.source);
	if(lookaheadMatch &amp;&amp; lookaheadMatch.index == w.matchStart) {
		var text = lookaheadMatch[1];
		if(config.browser.isIE)
			text = text.replace(/\n/g,&quot;\r&quot;);
		createTiddlyElement(w.output,&quot;pre&quot;,null,null,text);
		w.nextMatch = lookaheadRegExp.lastIndex;
	}
};

// @Deprecated: Use &lt;br&gt; or &lt;br /&gt; instead of &lt;&lt;br&gt;&gt;
config.macros.br = {};
config.macros.br.handler = function(place)
{
	createTiddlyElement(place,&quot;br&quot;);
};

// Find an entry in an array. Returns the array index or null
// @Deprecated: Use indexOf instead
Array.prototype.find = function(item)
{
	var i = this.indexOf(item);
	return i == -1 ? null : i;
};

// Load a tiddler from an HTML DIV. The caller should make sure to later call Tiddler.changed()
// @Deprecated: Use store.getLoader().internalizeTiddler instead
Tiddler.prototype.loadFromDiv = function(divRef,title)
{
	return store.getLoader().internalizeTiddler(store,this,title,divRef);
};

// Format the text for storage in an HTML DIV
// @Deprecated Use store.getSaver().externalizeTiddler instead.
Tiddler.prototype.saveToDiv = function()
{
	return store.getSaver().externalizeTiddler(store,this);
};

// @Deprecated: Use store.allTiddlersAsHtml() instead
function allTiddlersAsHtml()
{
	return store.allTiddlersAsHtml();
}

// @Deprecated: Use refreshPageTemplate instead
function applyPageTemplate(title)
{
	refreshPageTemplate(title);
}

// @Deprecated: Use story.displayTiddlers instead
function displayTiddlers(srcElement,titles,template,unused1,unused2,animate,unused3)
{
	story.displayTiddlers(srcElement,titles,template,animate);
}

// @Deprecated: Use story.displayTiddler instead
function displayTiddler(srcElement,title,template,unused1,unused2,animate,unused3)
{
	story.displayTiddler(srcElement,title,template,animate);
}

// @Deprecated: Use functions on right hand side directly instead
var createTiddlerPopup = Popup.create;
var scrollToTiddlerPopup = Popup.show;
var hideTiddlerPopup = Popup.remove;

// @Deprecated: Use right hand side directly instead
var regexpBackSlashEn = new RegExp(&quot;\\\\n&quot;,&quot;mg&quot;);
var regexpBackSlash = new RegExp(&quot;\\\\&quot;,&quot;mg&quot;);
var regexpBackSlashEss = new RegExp(&quot;\\\\s&quot;,&quot;mg&quot;);
var regexpNewLine = new RegExp(&quot;\n&quot;,&quot;mg&quot;);
var regexpCarriageReturn = new RegExp(&quot;\r&quot;,&quot;mg&quot;);

}
//}}}</pre>
</div>

<!-- pre-loaded tiddlers from coral database -->
<c:forEach var="tiddler" items="${tiddlers}">
	${tiddler.htmlDiv}
</c:forEach>

</div>
<!--POST-STOREAREA-->
<!--POST-BODY-START-->
<!--POST-BODY-END-->
<script type="text/javascript">

// Coral specifics
function debug(str) {
	var texto = document.getElementById("console").innerHTML;
	document.getElementById("console").innerHTML = texto + "\n" + str
}



//<![CDATA[
//
// Please note:
// 
// * This code is designed to be readable but for compactness it only includes brief comments. You can see fuller comments
//   in the project Subversion repository at http://svn.tiddlywiki.org/Trunk/core/
//
// * You should never need to modify this source code directly. TiddlyWiki is carefully designed to allow deep customisation
//   without changing the core code. Please consult the development group at http://groups.google.com/group/TiddlyWikiDev
// 

//--
//-- Configuration repository
//--

// Miscellaneous options
var config = {
	numRssItems: 20, // Number of items in the RSS feed
	animDuration: 400, // Duration of UI animations in milliseconds
	cascadeFast: 20, // Speed for cascade animations (higher == slower)
	cascadeSlow: 60, // Speed for EasterEgg cascade animations
	cascadeDepth: 5 // Depth of cascade animation
};

// Adaptors
config.adaptors = {};

// Backstage tasks
config.tasks = {};

// Annotations
config.annotations = {};

// Custom fields to be automatically added to new tiddlers
config.defaultCustomFields = {};

// Messages
config.messages = {
	messageClose: {},
	dates: {},
	tiddlerPopup: {}
};

// Options that can be set in the options panel and/or cookies
config.options = {
	chkRegExpSearch: false,
	chkCaseSensitiveSearch: false,
	chkAnimate: true,
	chkSaveBackups: true,
	chkAutoSave: false,
	chkGenerateAnRssFeed: false,
	chkSaveEmptyTemplate: false,
	chkOpenInNewWindow: true,
	chkToggleLinks: false,
	chkHttpReadOnly: false,
	chkForceMinorUpdate: false,
	chkConfirmDelete: true,
	chkInsertTabs: false,
	chkUsePreForStorage: true, // Whether to use <pre> format for storage
	chkDisplayStartupTime: false,
	txtBackupFolder: "",
	txtMainTab: "tabTimeline",
	txtMoreTab: "moreTabAll",
	txtMaxEditRows: "30",
	txtFileSystemCharSet: "UTF-8",
	txtTheme: ""
	};
config.optionsDesc = {};

// List of notification functions to be called when certain tiddlers are changed or deleted
config.notifyTiddlers = [
	{name: "StyleSheetLayout", notify: refreshStyles},
	{name: "StyleSheetColors", notify: refreshStyles},
	{name: "StyleSheet", notify: refreshStyles},
	{name: "StyleSheetPrint", notify: refreshStyles},
	{name: "PageTemplate", notify: refreshPageTemplate},
	{name: "SiteTitle", notify: refreshPageTitle},
	{name: "SiteSubtitle", notify: refreshPageTitle},
	{name: "ColorPalette", notify: refreshColorPalette},
	{name: null, notify: refreshDisplay}
];

// Default tiddler templates
var DEFAULT_VIEW_TEMPLATE = 1;
var DEFAULT_EDIT_TEMPLATE = 2;
config.tiddlerTemplates = {
	1: "ViewTemplate",
	2: "EditTemplate"
};

// More messages (rather a legacy layout that shouldn't really be like this)
config.views = {
	wikified: {
		tag: {}
	},
	editor: {
		tagChooser: {}
	}
};

// Backstage tasks
config.backstageTasks = ["save","sync","importTask","tweak","plugins"];

// Macros; each has a 'handler' member that is inserted later
config.macros = {
	today: {},
	version: {},
	search: {sizeTextbox: 15},
	tiddler: {},
	tag: {},
	tags: {},
	tagging: {},
	timeline: {},
	allTags: {},
	list: {
		all: {},
		missing: {},
		orphans: {},
		shadowed: {},
		touched: {},
		filter: {}
	},
	closeAll: {},
	permaview: {},
	saveChanges: {},
	slider: {},
	option: {},
	options: {},
	newTiddler: {},
	newJournal: {},
	tabs: {},
	gradient: {},
	message: {},
	view: {},
	edit: {},
	tagChooser: {},
	toolbar: {},
	plugins: {},
	refreshDisplay: {},
	importTiddlers: {},
	uploadImportTiddlers: {},
	sync: {},
	annotations: {}
};

// Commands supported by the toolbar macro
config.commands = {
	closeTiddler: {},
	closeOthers: {},
	editTiddler: {},
	saveTiddler: {hideReadOnly: true},
	cancelTiddler: {},
	deleteTiddler: {hideReadOnly: true},
	permalink: {},
	references: {type: "popup"},
	jump: {type: "popup"},
	syncing: {type: "popup"},
	fields: {type: "popup"}
};

// Browser detection... In a very few places, there's nothing else for it but to know what browser we're using.
config.userAgent = navigator.userAgent.toLowerCase();
config.browser = {
	isIE: config.userAgent.indexOf("msie") != -1 && config.userAgent.indexOf("opera") == -1,
	isGecko: config.userAgent.indexOf("gecko") != -1,
	ieVersion: /MSIE (\d.\d)/i.exec(config.userAgent), // config.browser.ieVersion[1], if it exists, will be the IE version string, eg "6.0"
	isSafari: config.userAgent.indexOf("applewebkit") != -1,
	isBadSafari: !((new RegExp("[\u0150\u0170]","g")).test("\u0150")),
	firefoxDate: /gecko\/(\d{8})/i.exec(config.userAgent), // config.browser.firefoxDate[1], if it exists, will be Firefox release date as "YYYYMMDD"
	isOpera: config.userAgent.indexOf("opera") != -1,
	isLinux: config.userAgent.indexOf("linux") != -1,
	isUnix: config.userAgent.indexOf("x11") != -1,
	isMac: config.userAgent.indexOf("mac") != -1,
	isWindows: config.userAgent.indexOf("win") != -1
};

// Basic regular expressions
config.textPrimitives = {
	upperLetter: "[A-Z\u00c0-\u00de\u0150\u0170]",
	lowerLetter: "[a-z0-9_\\-\u00df-\u00ff\u0151\u0171]",
	anyLetter:   "[A-Za-z0-9_\\-\u00c0-\u00de\u00df-\u00ff\u0150\u0170\u0151\u0171]",
	anyLetterStrict: "[A-Za-z0-9\u00c0-\u00de\u00df-\u00ff\u0150\u0170\u0151\u0171]"
};
if(config.browser.isBadSafari) {
	config.textPrimitives = {
		upperLetter: "[A-Z\u00c0-\u00de]",
		lowerLetter: "[a-z0-9_\\-\u00df-\u00ff]",
		anyLetter:   "[A-Za-z0-9_\\-\u00c0-\u00de\u00df-\u00ff]",
		anyLetterStrict: "[A-Za-z0-9\u00c0-\u00de\u00df-\u00ff]"
	};
}
config.textPrimitives.sliceSeparator = "::";
config.textPrimitives.sectionSeparator = "##";
config.textPrimitives.urlPattern = "(?:file|http|https|mailto|ftp|irc|news|data):[^\\s'\"]+(?:/|\\b)";
config.textPrimitives.unWikiLink = "~";
config.textPrimitives.wikiLink = "(?:(?:" + config.textPrimitives.upperLetter + "+" +
	config.textPrimitives.lowerLetter + "+" +
	config.textPrimitives.upperLetter +
	config.textPrimitives.anyLetter + "*)|(?:" +
	config.textPrimitives.upperLetter + "{2,}" +
	config.textPrimitives.lowerLetter + "+))";

config.textPrimitives.cssLookahead = "(?:(" + config.textPrimitives.anyLetter + "+)\\(([^\\)\\|\\n]+)(?:\\):))|(?:(" + config.textPrimitives.anyLetter + "+):([^;\\|\\n]+);)";
config.textPrimitives.cssLookaheadRegExp = new RegExp(config.textPrimitives.cssLookahead,"mg");

config.textPrimitives.brackettedLink = "\\[\\[([^\\]]+)\\]\\]";
config.textPrimitives.titledBrackettedLink = "\\[\\[([^\\[\\]\\|]+)\\|([^\\[\\]\\|]+)\\]\\]";
config.textPrimitives.tiddlerForcedLinkRegExp = new RegExp("(?:" + config.textPrimitives.titledBrackettedLink + ")|(?:" +
	config.textPrimitives.brackettedLink + ")|(?:" +
	config.textPrimitives.urlPattern + ")","mg");
config.textPrimitives.tiddlerAnyLinkRegExp = new RegExp("("+ config.textPrimitives.wikiLink + ")|(?:" +
	config.textPrimitives.titledBrackettedLink + ")|(?:" +
	config.textPrimitives.brackettedLink + ")|(?:" +
	config.textPrimitives.urlPattern + ")","mg");

config.glyphs = {
	browsers: [
		function() {return config.browser.isIE;},
		function() {return true;}
	],
	currBrowser: null,
	codes: {
		downTriangle: ["\u25BC","\u25BE"],
		downArrow: ["\u2193","\u2193"],
		bentArrowLeft: ["\u2190","\u21A9"],
		bentArrowRight: ["\u2192","\u21AA"]
	}
};

//--
//-- Shadow tiddlers
//--

config.shadowTiddlers = {
	StyleSheet: "",
	MarkupPreHead: "",
	MarkupPostHead: "",
	MarkupPreBody: "",
	MarkupPostBody: "",
	TabTimeline: '<<timeline>>',
	TabAll: '<<list all>>',
	TabTags: '<<allTags excludeLists>>',
	TabMoreMissing: '<<list missing>>',
	TabMoreOrphans: '<<list orphans>>',
	TabMoreShadowed: '<<list shadowed>>',
	AdvancedOptions: '<<options>>',
	PluginManager: '<<plugins>>',
	TabNamespaces: '<<namespaces>>'
};

//--
//-- Translateable strings
//--

// Strings in "double quotes" should be translated; strings in 'single quotes' should be left alone

merge(config.options,{
	txtUserName: "YourName"});

merge(config.tasks,{
	save: {text: "save", tooltip: "Save your changes to this TiddlyWiki", action: saveChanges},
	sync: {text: "sync", tooltip: "Synchronise changes with other TiddlyWiki files and servers", content: '<<sync>>'},
	importTask: {text: "import", tooltip: "Import tiddlers and plugins from other TiddlyWiki files and servers", content: '<<uploadImportTiddlers>>'},
	tweak: {text: "tweak", tooltip: "Tweak the appearance and behaviour of TiddlyWiki", content: '<<options>>'},
	plugins: {text: "plugins", tooltip: "Manage installed plugins", content: '<<plugins>>'}
});

// Options that can be set in the options panel and/or cookies
merge(config.optionsDesc,{
	txtUserName: "Username for signing your edits",
	chkRegExpSearch: "Enable regular expressions for searches",
	chkCaseSensitiveSearch: "Case-sensitive searching",
	chkAnimate: "Enable animations",
	chkSaveBackups: "Keep backup file when saving changes",
	chkAutoSave: "Automatically save changes",
	chkGenerateAnRssFeed: "Generate an RSS feed when saving changes",
	chkSaveEmptyTemplate: "Generate an empty template when saving changes",
	chkOpenInNewWindow: "Open external links in a new window",
	chkToggleLinks: "Clicking on links to open tiddlers causes them to close",
	chkHttpReadOnly: "Hide editing features when viewed over HTTP",
	chkForceMinorUpdate: "Don't update modifier username and date when editing tiddlers",
	chkConfirmDelete: "Require confirmation before deleting tiddlers",
	chkInsertTabs: "Use the tab key to insert tab characters instead of moving between fields",
	txtBackupFolder: "Name of folder to use for backups",
	txtMaxEditRows: "Maximum number of rows in edit boxes",
	txtFileSystemCharSet: "Default character set for saving changes (Firefox/Mozilla only)"});

merge(config.messages,{
	customConfigError: "Problems were encountered loading plugins. See PluginManager for details",
	pluginError: "Error: %0",
	pluginDisabled: "Not executed because disabled via 'systemConfigDisable' tag",
	pluginForced: "Executed because forced via 'systemConfigForce' tag",
	pluginVersionError: "Not executed because this plugin needs a newer version of TiddlyWiki",
	nothingSelected: "Nothing is selected. You must select one or more items first",
	savedSnapshotError: "It appears that this TiddlyWiki has been incorrectly saved. Please see http://www.tiddlywiki.com/#DownloadSoftware for details",
	subtitleUnknown: "(unknown)",
	undefinedTiddlerToolTip: "The tiddler '%0' doesn't yet exist",
	shadowedTiddlerToolTip: "The tiddler '%0' doesn't yet exist, but has a pre-defined shadow value",
	tiddlerLinkTooltip: "%0 - %1, %2",
	externalLinkTooltip: "External link to %0",
	noTags: "There are no tagged tiddlers",
	notFileUrlError: "You need to save this TiddlyWiki to a file before you can save changes",
	cantSaveError: "It's not possible to save changes. Possible reasons include:\n- your browser doesn't support saving (Firefox, Internet Explorer, Safari and Opera all work if properly configured)\n- the pathname to your TiddlyWiki file contains illegal characters\n- the TiddlyWiki HTML file has been moved or renamed",
	invalidFileError: "The original file '%0' does not appear to be a valid TiddlyWiki",
	backupSaved: "Backup saved",
	backupFailed: "Failed to save backup file",
	rssSaved: "RSS feed saved",
	rssFailed: "Failed to save RSS feed file",
	emptySaved: "Empty template saved",
	emptyFailed: "Failed to save empty template file",
	mainSaved: "Main TiddlyWiki file saved",
	mainFailed: "Failed to save main TiddlyWiki file. Your changes have not been saved",
	macroError: "Error in macro <<\%0>>",
	macroErrorDetails: "Error while executing macro <<\%0>>:\n%1",
	missingMacro: "No such macro",
	overwriteWarning: "A tiddler named '%0' already exists. Choose OK to overwrite it",
	unsavedChangesWarning: "WARNING! There are unsaved changes in TiddlyWiki\n\nChoose OK to save\nChoose CANCEL to discard",
	confirmExit: "--------------------------------\n\nThere are unsaved changes in TiddlyWiki. If you continue you will lose those changes\n\n--------------------------------",
	saveInstructions: "SaveChanges",
	unsupportedTWFormat: "Unsupported TiddlyWiki format '%0'",
	tiddlerSaveError: "Error when saving tiddler '%0'",
	tiddlerLoadError: "Error when loading tiddler '%0'",
	wrongSaveFormat: "Cannot save with storage format '%0'. Using standard format for save.",
	invalidFieldName: "Invalid field name %0",
	fieldCannotBeChanged: "Field '%0' cannot be changed",
	loadingMissingTiddler: "Attempting to retrieve the tiddler '%0' from the '%1' server at:\n\n'%2' in the workspace '%3'"});

merge(config.messages.messageClose,{
	text: "close",
	tooltip: "close this message area"});

config.messages.backstage = {
	open: {text: "backstage", tooltip: "Open the backstage area to perform authoring and editing tasks"},
	close: {text: "close", tooltip: "Close the backstage area"},
	prompt: "backstage: ",
	decal: {
		edit: {text: "edit", tooltip: "Edit the tiddler '%0'"}
	}
};

config.messages.listView = {
	tiddlerTooltip: "Click for the full text of this tiddler",
	previewUnavailable: "(preview not available)"
};

config.messages.dates.months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November","December"];
config.messages.dates.days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
config.messages.dates.shortMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
config.messages.dates.shortDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
// suffixes for dates, eg "1st","2nd","3rd"..."30th","31st"
config.messages.dates.daySuffixes = ["st","nd","rd","th","th","th","th","th","th","th",
		"th","th","th","th","th","th","th","th","th","th",
		"st","nd","rd","th","th","th","th","th","th","th",
		"st"];
config.messages.dates.am = "am";
config.messages.dates.pm = "pm";

merge(config.messages.tiddlerPopup,{
	});

merge(config.views.wikified.tag,{
	labelNoTags: "no tags",
	labelTags: "tags: ",
	openTag: "Open tag '%0'",
	tooltip: "Show tiddlers tagged with '%0'",
	openAllText: "Open all",
	openAllTooltip: "Open all of these tiddlers",
	popupNone: "No other tiddlers tagged with '%0'"});

merge(config.views.wikified,{
	defaultText: "The tiddler '%0' doesn't yet exist. Double-click to create it",
	defaultModifier: "(missing)",
	shadowModifier: "(built-in shadow tiddler)",
	dateFormat: "DD MMM YYYY",
	createdPrompt: "created"});

merge(config.views.editor,{
	tagPrompt: "Type tags separated with spaces, [[use double square brackets]] if necessary, or add existing",
	defaultText: "Type the text for '%0'"});

merge(config.views.editor.tagChooser,{
	text: "tags",
	tooltip: "Choose existing tags to add to this tiddler",
	popupNone: "There are no tags defined",
	tagTooltip: "Add the tag '%0'"});

merge(config.messages,{
	sizeTemplates:
		[
		{unit: 1024*1024*1024, template: "%0\u00a0GB"},
		{unit: 1024*1024, template: "%0\u00a0MB"},
		{unit: 1024, template: "%0\u00a0KB"},
		{unit: 1, template: "%0\u00a0B"}
		]});

merge(config.macros.search,{
	label: "search",
	prompt: "Search this TiddlyWiki",
	accessKey: "F",
	successMsg: "%0 tiddlers found matching %1",
	failureMsg: "No tiddlers found matching %0"});

merge(config.macros.tagging,{
	label: "tagging: ",
	labelNotTag: "not tagging",
	tooltip: "List of tiddlers tagged with '%0'"});

merge(config.macros.timeline,{
	dateFormat: "DD MMM YYYY"});

merge(config.macros.allTags,{
	tooltip: "Show tiddlers tagged with '%0'",
	noTags: "There are no tagged tiddlers"});

config.macros.list.all.prompt = "All tiddlers in alphabetical order";
config.macros.list.missing.prompt = "Tiddlers that have links to them but are not defined";
config.macros.list.orphans.prompt = "Tiddlers that are not linked to from any other tiddlers";
config.macros.list.shadowed.prompt = "Tiddlers shadowed with default contents";
config.macros.list.touched.prompt = "Tiddlers that have been modified locally";

merge(config.macros.closeAll,{
	label: "close all",
	prompt: "Close all displayed tiddlers (except any that are being edited)"});

merge(config.macros.permaview,{
	label: "permaview",
	prompt: "Link to an URL that retrieves all the currently displayed tiddlers"});

merge(config.macros.saveChanges,{
	label: "save changes",
	prompt: "Save all tiddlers to create a new TiddlyWiki",
	accessKey: "S"});

merge(config.macros.newTiddler,{
	label: "new tiddler",
	prompt: "Create a new tiddler",
	title: "New Tiddler",
	accessKey: "N"});

merge(config.macros.newJournal,{
	label: "new journal",
	prompt: "Create a new tiddler from the current date and time",
	accessKey: "J"});

merge(config.macros.options,{
	wizardTitle: "Tweak advanced options",
	step1Title: "These options are saved in cookies in your browser",
	step1Html: "<input type='hidden' name='markList'></input><br><input type='checkbox' checked='false' name='chkUnknown'>Show unknown options</input>",
	unknownDescription: "//(unknown)//",
	listViewTemplate: {
		columns: [
			{name: 'Option', field: 'option', title: "Option", type: 'String'},
			{name: 'Description', field: 'description', title: "Description", type: 'WikiText'},
			{name: 'Name', field: 'name', title: "Name", type: 'String'}
			],
		rowClasses: [
			{className: 'lowlight', field: 'lowlight'}
			]}
	});

merge(config.macros.plugins,{
	wizardTitle: "Manage plugins",
	step1Title: "Currently loaded plugins",
	step1Html: "<input type='hidden' name='markList'></input>", // DO NOT TRANSLATE
	skippedText: "(This plugin has not been executed because it was added since startup)",
	noPluginText: "There are no plugins installed",
	confirmDeleteText: "Are you sure you want to delete these plugins:\n\n%0",
	removeLabel: "remove systemConfig tag",
	removePrompt: "Remove systemConfig tag",
	deleteLabel: "delete",
	deletePrompt: "Delete these tiddlers forever",
	listViewTemplate: {
		columns: [
			{name: 'Selected', field: 'Selected', rowName: 'title', type: 'Selector'},
			{name: 'Tiddler', field: 'tiddler', title: "Tiddler", type: 'Tiddler'},
			{name: 'Size', field: 'size', tiddlerLink: 'size', title: "Size", type: 'Size'},
			{name: 'Forced', field: 'forced', title: "Forced", tag: 'systemConfigForce', type: 'TagCheckbox'},
			{name: 'Disabled', field: 'disabled', title: "Disabled", tag: 'systemConfigDisable', type: 'TagCheckbox'},
			{name: 'Executed', field: 'executed', title: "Loaded", type: 'Boolean', trueText: "Yes", falseText: "No"},
			{name: 'Startup Time', field: 'startupTime', title: "Startup Time", type: 'String'},
			{name: 'Error', field: 'error', title: "Status", type: 'Boolean', trueText: "Error", falseText: "OK"},
			{name: 'Log', field: 'log', title: "Log", type: 'StringList'}
			],
		rowClasses: [
			{className: 'error', field: 'error'},
			{className: 'warning', field: 'warning'}
			]}
	});

merge(config.macros.toolbar,{
	moreLabel: "more",
	morePrompt: "Reveal further commands"
	});

merge(config.macros.refreshDisplay,{
	label: "refresh",
	prompt: "Redraw the entire TiddlyWiki display"
	});

merge(config.macros.importTiddlers,{
	readOnlyWarning: "You cannot import into a read-only TiddlyWiki file. Try opening it from a file:// URL",
	wizardTitle: "Import tiddlers from another file or server",
	step1Title: "Step 1: Locate the server or TiddlyWiki file",
	step1Html: "Specify the type of the server: <select name='selTypes'><option value=''>Choose...</option></select><br>Enter the URL or pathname here: <input type='text' size=50 name='txtPath'><br>...or browse for a file: <input type='file' size=50 name='txtBrowse'><br><hr>...or select a pre-defined feed: <select name='selFeeds'><option value=''>Choose...</option></select>",
	openLabel: "open",
	openPrompt: "Open the connection to this file or server",
	openError: "There were problems fetching the tiddlywiki file",
	statusOpenHost: "Opening the host",
	statusGetWorkspaceList: "Getting the list of available workspaces",
	step2Title: "Step 2: Choose the workspace",
	step2Html: "Enter a workspace name: <input type='text' size=50 name='txtWorkspace'><br>...or select a workspace: <select name='selWorkspace'><option value=''>Choose...</option></select>",
	cancelLabel: "cancel",
	cancelPrompt: "Cancel this import",
	statusOpenWorkspace: "Opening the workspace",
	statusGetTiddlerList: "Getting the list of available tiddlers",
	step3Title: "Step 3: Choose the tiddlers to import",
	step3Html: "<input type='hidden' name='markList'></input><br><input type='checkbox' checked='true' name='chkSync'>Keep these tiddlers linked to this server so that you can synchronise subsequent changes</input><br><input type='checkbox' name='chkSave'>Save the details of this server in a 'systemServer' tiddler called:</input> <input type='text' size=25 name='txtSaveTiddler'>",
	importLabel: "import",
	importPrompt: "Import these tiddlers",
	confirmOverwriteText: "Are you sure you want to overwrite these tiddlers:\n\n%0",
	step4Title: "Step 4: Importing %0 tiddler(s)",
	step4Html: "<input type='hidden' name='markReport'></input>", // DO NOT TRANSLATE
	doneLabel: "done",
	donePrompt: "Close this wizard",
	statusDoingImport: "Importing tiddlers",
	statusDoneImport: "All tiddlers imported",
	systemServerNamePattern: "%2 on %1",
	systemServerNamePatternNoWorkspace: "%1",
	confirmOverwriteSaveTiddler: "The tiddler '%0' already exists. Click 'OK' to overwrite it with the details of this server, or 'Cancel' to leave it unchanged",
	serverSaveTemplate: "|''Type:''|%0|\n|''URL:''|%1|\n|''Workspace:''|%2|\n\nThis tiddler was automatically created to record the details of this server",
	serverSaveModifier: "(System)",
	listViewTemplate: {
		columns: [
			{name: 'Selected', field: 'Selected', rowName: 'title', type: 'Selector'},
			{name: 'Tiddler', field: 'tiddler', title: "Tiddler", type: 'Tiddler'},
			{name: 'Size', field: 'size', tiddlerLink: 'size', title: "Size", type: 'Size'},
			{name: 'Tags', field: 'tags', title: "Tags", type: 'Tags'}
			],
		rowClasses: [
			]}
	});

	merge(config.macros.uploadImportTiddlers,{
		readOnlyWarning: "You cannot import into a read-only TiddlyWiki file. Try opening it from a file:// URL",
		wizardTitle: "Import tiddlers from another file",
		step1Title: "Step 1: choose the TiddlyWiki file",
		step1Html: "Browse for a file: <input type='file' size=50 name='txtBrowse'><iframe id='iframeUploadImport' name='iframeUploadImport' style='display:none'></iframe>",
		openLabel: "open",
		openPrompt: "Open the connection to this file or server",
		openError: "There were problems fetching the tiddlywiki file",
		statusOpenHost: "Opening the host",
		statusGetWorkspaceList: "Getting the list of available workspaces",
		step2Title: "Step 2: Choose the workspace",
		step2Html: "Enter a workspace name: <input type='text' size=50 name='txtWorkspace'><br>...or select a workspace: <select name='selWorkspace'><option value=''>Choose...</option></select>",
		cancelLabel: "cancel",
		cancelPrompt: "Cancel this import",
		statusOpenWorkspace: "Opening the workspace",
		statusGetTiddlerList: "Getting the list of available tiddlers",
		step3Title: "Step 3: Choose the tiddlers to import",
		step3Html: "<input type='hidden' name='markList'></input><br>",
		importLabel: "import",
		importPrompt: "Import these tiddlers",
		confirmOverwriteText: "Are you sure you want to overwrite these tiddlers:\n\n%0",
		step4Title: "Step 4: Importing %0 tiddler(s)",
		step4Html: "<input type='hidden' name='markReport'></input>", // DO NOT TRANSLATE
		doneLabel: "done",
		donePrompt: "Close this wizard",
		statusDoingImport: "Importing tiddlers",
		statusDoneImport: "All tiddlers imported",
		systemServerNamePattern: "%2 on %1",
		systemServerNamePatternNoWorkspace: "%1",
		confirmOverwriteSaveTiddler: "The tiddler '%0' already exists. Click 'OK' to overwrite it with the details of this server, or 'Cancel' to leave it unchanged",
		serverSaveTemplate: "|''Type:''|%0|\n|''URL:''|%1|\n|''Workspace:''|%2|\n\nThis tiddler was automatically created to record the details of this server",
		serverSaveModifier: "(System)",
		listViewTemplate: {
			columns: [
				{name: 'Selected', field: 'Selected', rowName: 'title', type: 'Selector'},
				{name: 'Tiddler', field: 'tiddler', title: "Tiddler", type: 'Tiddler'},
				{name: 'Size', field: 'size', tiddlerLink: 'size', title: "Size", type: 'Size'},
				{name: 'Tags', field: 'tags', title: "Tags", type: 'Tags'}
				],
			rowClasses: [
				]}
		});


merge(config.macros.sync,{
	listViewTemplate: {
		columns: [
			{name: 'Selected', field: 'selected', rowName: 'title', type: 'Selector'},
			{name: 'Tiddler', field: 'tiddler', title: "Tiddler", type: 'Tiddler'},
			{name: 'Server Type', field: 'serverType', title: "Server type", type: 'String'},
			{name: 'Server Host', field: 'serverHost', title: "Server host", type: 'String'},
			{name: 'Server Workspace', field: 'serverWorkspace', title: "Server workspace", type: 'String'},
			{name: 'Status', field: 'status', title: "Synchronisation status", type: 'String'},
			{name: 'Server URL', field: 'serverUrl', title: "Server URL", text: "View", type: 'Link'}
			],
		rowClasses: [
			],
		buttons: [
			{caption: "Sync these tiddlers", name: 'sync'}
			]},
	wizardTitle: "Synchronize with external servers and files",
	step1Title: "Choose the tiddlers you want to synchronize",
	step1Html: "<input type='hidden' name='markList'></input>", // DO NOT TRANSLATE
	syncLabel: "sync",
	syncPrompt: "Sync these tiddlers",
	hasChanged: "Changed while unplugged",
	hasNotChanged: "Unchanged while unplugged",
	syncStatusList: {
		none: {text: "...", color: "transparent"},
		changedServer: {text: "Changed on server", color: '#80ff80'},
		changedLocally: {text: "Changed while unplugged", color: '#80ff80'},
		changedBoth: {text: "Changed while unplugged and on server", color: '#ff8080'},
		notFound: {text: "Not found on server", color: '#ffff80'},
		putToServer: {text: "Saved update on server", color: '#ff80ff'},
		gotFromServer: {text: "Retrieved update from server", color: '#80ffff'}
		}
	});

merge(config.macros.annotations,{
	});

merge(config.commands.closeTiddler,{
	text: "close",
	tooltip: "Close this tiddler"});

merge(config.commands.closeOthers,{
	text: "close others",
	tooltip: "Close all other tiddlers"});

merge(config.commands.editTiddler,{
	text: "edit",
	tooltip: "Edit this tiddler",
	readOnlyText: "view",
	readOnlyTooltip: "View the source of this tiddler"});

merge(config.commands.saveTiddler,{
	text: "done",
	tooltip: "Save changes to this tiddler"});

merge(config.commands.cancelTiddler,{
	text: "cancel",
	tooltip: "Undo changes to this tiddler",
	warning: "Are you sure you want to abandon your changes to '%0'?",
	readOnlyText: "done",
	readOnlyTooltip: "View this tiddler normally"});

merge(config.commands.deleteTiddler,{
	text: "delete",
	tooltip: "Delete this tiddler",
	warning: "Are you sure you want to delete '%0'?"});

merge(config.commands.permalink,{
	text: "permalink",
	tooltip: "Permalink for this tiddler"});

merge(config.commands.references,{
	text: "references",
	tooltip: "Show tiddlers that link to this one",
	popupNone: "No references"});

merge(config.commands.jump,{
	text: "jump",
	tooltip: "Jump to another open tiddler"});

merge(config.commands.syncing,{
	text: "syncing",
	tooltip: "Control synchronisation of this tiddler with a server or external file",
	currentlySyncing: "<div>Currently syncing via <span class='popupHighlight'>'%0'</span> to:</"+"div><div>host: <span class='popupHighlight'>%1</span></"+"div><div>workspace: <span class='popupHighlight'>%2</span></"+"div>", // Note escaping of closing <div> tag
	notCurrentlySyncing: "Not currently syncing",
	captionUnSync: "Stop synchronising this tiddler",
	chooseServer: "Synchronise this tiddler with another server:",
	currServerMarker: "\u25cf ",
	notCurrServerMarker: "  "});

merge(config.commands.fields,{
	text: "fields",
	tooltip: "Show the extended fields of this tiddler",
	emptyText: "There are no extended fields for this tiddler",
	listViewTemplate: {
		columns: [
			{name: 'Field', field: 'field', title: "Field", type: 'String'},
			{name: 'Value', field: 'value', title: "Value", type: 'String'}
			],
		rowClasses: [
			],
		buttons: [
			]}});

merge(config.shadowTiddlers,{
	DefaultTiddlers: "GettingStarted",
	MainMenu: "GettingStarted",
	SiteTitle: "My TiddlyWiki",
	SiteSubtitle: "a reusable non-linear personal web notebook",
	SiteUrl: "http://www.tiddlywiki.com/",
	SideBarOptions: '<<thisNamespace>><<search>><<closeAll>><<permaview>><<newTiddler>><<newJournal "DD MMM YYYY" "journal">><<saveChangesOnServer>><<slider chkSliderOptionsPanel OptionsPanel "options »" "Change TiddlyWiki advanced options">>',
	SideBarTabs: '<<tabs txtMainTab Time Timeline TabTimeline All "All tiddlers" TabAll Tags "All tags" TabTags NS "All namespaces" TabNamespaces More "More lists" TabMore>>',
	TabMore: '<<tabs txtMoreTab "Missing" "Missing tiddlers" TabMoreMissing "Orphans" "Orphaned tiddlers" TabMoreOrphans "Shadowed" "Shadowed tiddlers" TabMoreShadowed>>'});

merge(config.annotations,{
	AdvancedOptions: "This shadow tiddler provides access to several advanced options",
	ColorPalette: "These values in this shadow tiddler determine the colour scheme of the ~TiddlyWiki user interface",
	DefaultTiddlers: "The tiddlers listed in this shadow tiddler will be automatically displayed when ~TiddlyWiki starts up",
	EditTemplate: "The HTML template in this shadow tiddler determines how tiddlers look while they are being edited",
	GettingStarted: "This shadow tiddler provides basic usage instructions",
	ImportTiddlers: "This shadow tiddler provides access to importing tiddlers",
	MainMenu: "This shadow tiddler is used as the contents of the main menu in the left-hand column of the screen",
	MarkupPreHead: "This tiddler is inserted at the top of the <head> section of the TiddlyWiki HTML file",
	MarkupPostHead: "This tiddler is inserted at the bottom of the <head> section of the TiddlyWiki HTML file",
	MarkupPreBody: "This tiddler is inserted at the top of the <body> section of the TiddlyWiki HTML file",
	MarkupPostBody: "This tiddler is inserted at the end of the <body> section of the TiddlyWiki HTML file immediately before the script block",
	OptionsPanel: "This shadow tiddler is used as the contents of the options panel slider in the right-hand sidebar",
	PageTemplate: "The HTML template in this shadow tiddler determines the overall ~TiddlyWiki layout",
	PluginManager: "This shadow tiddler provides access to the plugin manager",
	SideBarOptions: "This shadow tiddler is used as the contents of the option panel in the right-hand sidebar",
	SideBarTabs: "This shadow tiddler is used as the contents of the tabs panel in the right-hand sidebar",
	SiteSubtitle: "This shadow tiddler is used as the second part of the page title",
	SiteTitle: "This shadow tiddler is used as the first part of the page title",
	SiteUrl: "This shadow tiddler should be set to the full target URL for publication",
	StyleSheetColors: "This shadow tiddler contains CSS definitions related to the color of page elements. ''DO NOT EDIT THIS TIDDLER'', instead make your changes in the StyleSheet shadow tiddler.",
	StyleSheet: "This tiddler can contain custom CSS definitions",
	StyleSheetLayout: "This shadow tiddler contains CSS definitions related to the layout of page elements. ''DO NOT EDIT THIS TIDDLER'', instead make your changes in the StyleSheet shadow tiddler.",
	StyleSheetLocale: "This shadow tiddler contains CSS definitions related to the translation locale",
	StyleSheetPrint: "This shadow tiddler contains CSS definitions for printing",
	TabAll: "This shadow tiddler contains the contents of the 'All' tab in the right-hand sidebar",
	TabMore: "This shadow tiddler contains the contents of the 'More' tab in the right-hand sidebar",
	TabMoreMissing: "This shadow tiddler contains the contents of the 'Missing' tab in the right-hand sidebar",
	TabMoreOrphans: "This shadow tiddler contains the contents of the 'Orphans' tab in the right-hand sidebar",
	TabMoreShadowed: "This shadow tiddler contains the contents of the 'Shadowed' tab in the right-hand sidebar",
	TabTags: "This shadow tiddler contains the contents of the 'Tags' tab in the right-hand sidebar",
	TabTimeline: "This shadow tiddler contains the contents of the 'Timeline' tab in the right-hand sidebar",
	ViewTemplate: "The HTML template in this shadow tiddler determines how tiddlers look"
	});

//--
//-- Main
//--

var params = null; // Command line parameters
var store = null; // TiddlyWiki storage
var story = null; // Main story
var formatter = null; // Default formatters for the wikifier
config.parsers = {}; // Hashmap of alternative parsers for the wikifier
var anim = typeof Animator == "function" ? new Animator() : null; // Animation engine
var readOnly = false; // Whether we're in readonly mode
var highlightHack = null; // Embarrassing hack department...
var hadConfirmExit = false; // Don't warn more than once
var safeMode = false; // Disable all plugins and cookies
var showBackstage; // Whether to include the backstage area
var installedPlugins = []; // Information filled in when plugins are executed
var startingUp = false; // Whether we're in the process of starting up
var pluginInfo,tiddler; // Used to pass information to plugins in loadPlugins()

// Whether to use the JavaSaver applet
var useJavaSaver = config.browser.isSafari || config.browser.isOpera;

// Starting up
function main()
{
	var t10,t9,t8,t7,t6,t5,t4,t3,t2,t1,t0 = new Date();
	startingUp = true;
	window.onbeforeunload = function(e) {if(window.confirmExit) return confirmExit();};
	params = getParameters();
	if(params)
		params = params.parseParams("open",null,false);
	store = new TiddlyWiki();
	invokeParamifier(params,"oninit");
	story = new Story("tiddlerDisplay","tiddler");
	addEvent(document,"click",Popup.onDocumentClick);
	saveTest();
	loadOptionsCookie();
	for(var s=0; s<config.notifyTiddlers.length; s++)
		store.addNotification(config.notifyTiddlers[s].name,config.notifyTiddlers[s].notify);
	t1 = new Date();
	store.loadFromDiv("storeArea","store",true);
	t2 = new Date();
	loadShadowTiddlers();
	t3 = new Date();
	invokeParamifier(params,"onload");
	t4 = new Date();
	readOnly = (window.location.protocol == "file:") ? false : config.options.chkHttpReadOnly;
	showBackstage = !readOnly;
	var pluginProblem = loadPlugins();
	t5 = new Date();
	formatter = new Formatter(config.formatters);
	story.switchTheme(config.options.txtTheme);
	invokeParamifier(params,"onconfig");
	t6 = new Date();
	store.notifyAll();
	t7 = new Date();
	restart();
	t8 = new Date();
	if(pluginProblem) {
		story.displayTiddler(null,"PluginManager");
		displayMessage(config.messages.customConfigError);
	}
	for(var m in config.macros) {
		if(config.macros[m].init)
			config.macros[m].init();
	}
	t9 = new Date();
	if(showBackstage)
		backstage.init();
	t10 = new Date();
	if(config.options.chkDisplayStartupTime) {
		displayMessage("LoadFromDiv " + (t2-t1) + " ms");
		displayMessage("LoadShadows " + (t3-t2) + " ms");
		displayMessage("LoadPlugins " + (t5-t4) + " ms");
		displayMessage("Notify " + (t7-t6) + " ms");
		displayMessage("Restart " + (t8-t7) + " ms");
		displayMessage("Macro init " + (t9-t8) + " ms");
		displayMessage("Total: " + (t10-t0) + " ms");
	}
	startingUp = false;
}

// Restarting
function restart()
{
	invokeParamifier(params,"onstart");
	if(story.isEmpty()) {
		var tiddlers = store.filterTiddlers(store.getTiddlerText("DefaultTiddlers"));
		story.displayTiddlers(null,tiddlers);
	}
	window.scrollTo(0,0);
}

function saveTest()
{
	var s = document.getElementById("saveTest");
	if(s.hasChildNodes())
		alert(config.messages.savedSnapshotError);
	s.appendChild(document.createTextNode("savetest"));
}

function loadShadowTiddlers()
{
	var shadows = new TiddlyWiki();
	shadows.loadFromDiv("shadowArea","shadows",true);
	shadows.forEachTiddler(function(title,tiddler){config.shadowTiddlers[title] = tiddler.text;});
	delete shadows;
}

function loadPlugins()
{
	if(safeMode)
		return false;
	var tiddlers = store.getTaggedTiddlers("systemConfig");
	var toLoad = [];
	var nLoaded = 0;
	var map = {};
	var nPlugins = tiddlers.length;
	installedPlugins = [];
	for(var i=0; i<nPlugins; i++) {
		var p = getPluginInfo(tiddlers[i]);
		installedPlugins[i] = p;
		var n = p.Name;
		if(n)
			map[n] = p;
		n = p.Source;
		if(n)
			map[n] = p;
	}
	var visit = function(p) {
		if(!p || p.done)
			return;
		p.done = 1;
		var reqs = p.Requires;
		if(reqs) {
			reqs = reqs.readBracketedList();
			for(var i=0; i<reqs.length; i++)
				visit(map[reqs[i]]);
		}
		toLoad.push(p);
	};
	for(i=0; i<nPlugins; i++)
		visit(installedPlugins[i]);
	for(i=0; i<toLoad.length; i++) {
		p = toLoad[i];
		pluginInfo = p;
		tiddler = p.tiddler;
		if(isPluginExecutable(p)) {
			if(isPluginEnabled(p)) {
				p.executed = true;
				var startTime = new Date();
				try {
					if(tiddler.text)
						window.eval(tiddler.text);
					nLoaded++;
				} catch(ex) {
					p.log.push(config.messages.pluginError.format([exceptionText(ex)]));
					p.error = true;
				}
				pluginInfo.startupTime = String((new Date()) - startTime) + "ms";
			} else {
				nPlugins--;
			}
		} else {
			p.warning = true;
		}
	}
	return nLoaded != nPlugins;
}

function getPluginInfo(tiddler)
{
	var p = store.getTiddlerSlices(tiddler.title,["Name","Description","Version","Requires","CoreVersion","Date","Source","Author","License","Browsers"]);
	p.tiddler = tiddler;
	p.title = tiddler.title;
	p.log = [];
	return p;
}

// Check that a particular plugin is valid for execution
function isPluginExecutable(plugin)
{
	if(plugin.tiddler.isTagged("systemConfigForce"))
		return verifyTail(plugin,true,config.messages.pluginForced);
	if(plugin["CoreVersion"]) {
		var coreVersion = plugin["CoreVersion"].split(".");
		var w = parseInt(coreVersion[0]) - version.major;
		if(w == 0 && coreVersion[1])
			w = parseInt(coreVersion[1]) - version.minor;
		if(w == 0 && coreVersion[2])
		 	w = parseInt(coreVersion[2]) - version.revision;
		if(w > 0)
			return verifyTail(plugin,false,config.messages.pluginVersionError);
		}
	return true;
}

function isPluginEnabled(plugin)
{
	if(plugin.tiddler.isTagged("systemConfigDisable"))
		return verifyTail(plugin,false,config.messages.pluginDisabled);
	return true;
}

function verifyTail(plugin,result,message)
{
	plugin.log.push(message);
	return result;
}

function invokeMacro(place,macro,params,wikifier,tiddler)
{
	try {
		var m = config.macros[macro];
		if(m && m.handler)
			m.handler(place,macro,params.readMacroParams(),wikifier,params,tiddler);
		else
			createTiddlyError(place,config.messages.macroError.format([macro]),config.messages.macroErrorDetails.format([macro,config.messages.missingMacro]));
	} catch(ex) {
		createTiddlyError(place,config.messages.macroError.format([macro]),config.messages.macroErrorDetails.format([macro,ex.toString()]));
	}
}

//--
//-- Paramifiers
//--

function getParameters()
{
	var p = null;
	if(window.location.hash) {
		p = decodeURI(window.location.hash.substr(1));
		if(config.browser.firefoxDate != null && config.browser.firefoxDate[1] < "20051111")
			p = convertUTF8ToUnicode(p);
	}
	return p;
}

function invokeParamifier(params,handler)
{
	if(!params || params.length == undefined || params.length <= 1)
		return;
	for(var t=1; t<params.length; t++) {
		var p = config.paramifiers[params[t].name];
		if(p && p[handler] instanceof Function)
			p[handler](params[t].value);
	}
}

config.paramifiers = {};

config.paramifiers.start = {
	oninit: function(v) {
		safeMode = v.toLowerCase() == "safe";
	}
};

config.paramifiers.open = {
	onstart: function(v) {
		story.displayTiddler("bottom",v,null,false,null);
	}
};

config.paramifiers.story = {
	onstart: function(v) {
		var list = store.getTiddlerText(v,"").parseParams("open",null,false);
		invokeParamifier(list,"onstart");
	}
};

config.paramifiers.search = {
	onstart: function(v) {
		story.search(v,false,false);
	}
};

config.paramifiers.searchRegExp = {
	onstart: function(v) {
		story.prototype.search(v,false,true);
	}
};

config.paramifiers.tag = {
	onstart: function(v) {
		var tagged = store.getTaggedTiddlers(v,"title");
		story.displayTiddlers(null,tagged,null,false,null);
	}
};

config.paramifiers.newTiddler = {
	onstart: function(v) {
		if(!readOnly) {
			story.displayTiddler(null,v,DEFAULT_EDIT_TEMPLATE);
			story.focusTiddler(v,"text");
		}
	}
};

config.paramifiers.newJournal = {
	onstart: function(v) {
		if(!readOnly) {
			var now = new Date();
			var title = now.formatString(v.trim());
			story.displayTiddler(null,title,DEFAULT_EDIT_TEMPLATE);
			story.focusTiddler(title,"text");
		}
	}
};

config.paramifiers.readOnly = {
	onconfig: function(v) {
		var p = v.toLowerCase();
		readOnly = p == "yes" ? true : (p == "no" ? false : readOnly);
	}
};


config.paramifiers.theme = {
	onconfig: function(v) {
		story.switchTheme(v);
	}
};

//--
//-- Formatter helpers
//--

function Formatter(formatters)
{
	this.formatters = [];
	var pattern = [];
	for(var n=0; n<formatters.length; n++) {
		pattern.push("(" + formatters[n].match + ")");
		this.formatters.push(formatters[n]);
	}
	this.formatterRegExp = new RegExp(pattern.join("|"),"mg");
}

config.formatterHelpers = {

	createElementAndWikify: function(w)
	{
		w.subWikifyTerm(createTiddlyElement(w.output,this.element),this.termRegExp);
	},

	inlineCssHelper: function(w)
	{
		var styles = [];
		config.textPrimitives.cssLookaheadRegExp.lastIndex = w.nextMatch;
		var lookaheadMatch = config.textPrimitives.cssLookaheadRegExp.exec(w.source);
		while(lookaheadMatch && lookaheadMatch.index == w.nextMatch) {
			var s,v;
			if(lookaheadMatch[1]) {
				s = lookaheadMatch[1].unDash();
				v = lookaheadMatch[2];
			} else {
				s = lookaheadMatch[3].unDash();
				v = lookaheadMatch[4];
			}
			if (s=="bgcolor")
				s = "backgroundColor";
			styles.push({style: s, value: v});
			w.nextMatch = lookaheadMatch.index + lookaheadMatch[0].length;
			config.textPrimitives.cssLookaheadRegExp.lastIndex = w.nextMatch;
			lookaheadMatch = config.textPrimitives.cssLookaheadRegExp.exec(w.source);
		}
		return styles;
	},

	applyCssHelper: function(e,styles)
	{
		for(var t=0; t< styles.length; t++) {
			try {
				e.style[styles[t].style] = styles[t].value;
			} catch (ex) {
			}
		}
	},

	enclosedTextHelper: function(w)
	{
		this.lookaheadRegExp.lastIndex = w.matchStart;
		var lookaheadMatch = this.lookaheadRegExp.exec(w.source);
		if(lookaheadMatch && lookaheadMatch.index == w.matchStart) {
			var text = lookaheadMatch[1];
			if(config.browser.isIE)
				text = text.replace(/\n/g,"\r");
			createTiddlyElement(w.output,this.element,null,null,text);
			w.nextMatch = lookaheadMatch.index + lookaheadMatch[0].length;
		}
	},

	isExternalLink: function(link)
	{
		if(store.tiddlerExists(link) || store.isShadowTiddler(link)) {
			return false;
		}
		var urlRegExp = new RegExp(config.textPrimitives.urlPattern,"mg");
		if(urlRegExp.exec(link)) {
			return true;
		}
		if (link.indexOf(".")!=-1 || link.indexOf("\\")!=-1 || link.indexOf("/")!=-1 || link.indexOf("#")!=-1) {
			return true;
		}
		return false;
	}

};

//--
//-- Standard formatters
//--

config.formatters = [
{
	name: "table",
	match: "^\\|(?:[^\\n]*)\\|(?:[fhck]?)$",
	lookaheadRegExp: /^\|([^\n]*)\|([fhck]?)$/mg,
	rowTermRegExp: /(\|(?:[fhck]?)$\n?)/mg,
	cellRegExp: /(?:\|([^\n\|]*)\|)|(\|[fhck]?$\n?)/mg,
	cellTermRegExp: /((?:\x20*)\|)/mg,
	rowTypes: {"c":"caption", "h":"thead", "":"tbody", "f":"tfoot"},
	handler: function(w)
	{
		var table = createTiddlyElement(w.output,"table",null,"twtable");
		var prevColumns = [];
		var currRowType = null;
		var rowContainer;
		var rowCount = 0;
		w.nextMatch = w.matchStart;
		this.lookaheadRegExp.lastIndex = w.nextMatch;
		var lookaheadMatch = this.lookaheadRegExp.exec(w.source);
		while(lookaheadMatch && lookaheadMatch.index == w.nextMatch) {
			var nextRowType = lookaheadMatch[2];
			if(nextRowType == "k") {
				table.className = lookaheadMatch[1];
				w.nextMatch += lookaheadMatch[0].length+1;
			} else {
				if(nextRowType != currRowType) {
					rowContainer = createTiddlyElement(table,this.rowTypes[nextRowType]);
					currRowType = nextRowType;
				}
				if(currRowType == "c") {
					// Caption
					w.nextMatch++;
					if(rowContainer != table.firstChild)
						table.insertBefore(rowContainer,table.firstChild);
					rowContainer.setAttribute("align",rowCount == 0?"top":"bottom");
					w.subWikifyTerm(rowContainer,this.rowTermRegExp);
				} else {
					var theRow = createTiddlyElement(rowContainer,"tr",null,(rowCount&1)?"oddRow":"evenRow");
					theRow.onmouseover = function() {addClass(this,"hoverRow");};
					theRow.onmouseout = function() {removeClass(this,"hoverRow");};
					this.rowHandler(w,theRow,prevColumns);
					rowCount++;
				}
			}
			this.lookaheadRegExp.lastIndex = w.nextMatch;
			lookaheadMatch = this.lookaheadRegExp.exec(w.source);
		}
	},
	rowHandler: function(w,e,prevColumns)
	{
		var col = 0;
		var colSpanCount = 1;
		var prevCell = null;
		this.cellRegExp.lastIndex = w.nextMatch;
		var cellMatch = this.cellRegExp.exec(w.source);
		while(cellMatch && cellMatch.index == w.nextMatch) {
			if(cellMatch[1] == "~") {
				// Rowspan
				var last = prevColumns[col];
				if(last) {
					last.rowSpanCount++;
					last.element.setAttribute("rowspan",last.rowSpanCount);
					last.element.setAttribute("rowSpan",last.rowSpanCount); // Needed for IE
					last.element.valign = "center";
				}
				w.nextMatch = this.cellRegExp.lastIndex-1;
			} else if(cellMatch[1] == ">") {
				// Colspan
				colSpanCount++;
				w.nextMatch = this.cellRegExp.lastIndex-1;
			} else if(cellMatch[2]) {
				// End of row
				if(prevCell && colSpanCount > 1) {
					prevCell.setAttribute("colspan",colSpanCount);
					prevCell.setAttribute("colSpan",colSpanCount); // Needed for IE
				}
				w.nextMatch = this.cellRegExp.lastIndex;
				break;
			} else {
				// Cell
				w.nextMatch++;
				var styles = config.formatterHelpers.inlineCssHelper(w);
				var spaceLeft = false;
				var chr = w.source.substr(w.nextMatch,1);
				while(chr == " ") {
					spaceLeft = true;
					w.nextMatch++;
					chr = w.source.substr(w.nextMatch,1);
				}
				var cell;
				if(chr == "!") {
					cell = createTiddlyElement(e,"th");
					w.nextMatch++;
				} else {
					cell = createTiddlyElement(e,"td");
				}
				prevCell = cell;
				prevColumns[col] = {rowSpanCount:1,element:cell};
				if(colSpanCount > 1) {
					cell.setAttribute("colspan",colSpanCount);
					cell.setAttribute("colSpan",colSpanCount); // Needed for IE
					colSpanCount = 1;
				}
				config.formatterHelpers.applyCssHelper(cell,styles);
				w.subWikifyTerm(cell,this.cellTermRegExp);
				if(w.matchText.substr(w.matchText.length-2,1) == " ") // spaceRight
					cell.align = spaceLeft ? "center" : "left";
				else if(spaceLeft)
					cell.align = "right";
				w.nextMatch--;
			}
			col++;
			this.cellRegExp.lastIndex = w.nextMatch;
			cellMatch = this.cellRegExp.exec(w.source);
		}
	}
},

{
	name: "heading",
	match: "^!{1,6}",
	termRegExp: /(\n)/mg,
	handler: function(w)
	{
		w.subWikifyTerm(createTiddlyElement(w.output,"h" + w.matchLength),this.termRegExp);
	}
},

{
	name: "list",
	match: "^(?:[\\*#;:]+)",
	lookaheadRegExp: /^(?:(?:(\*)|(#)|(;)|(:))+)/mg,
	termRegExp: /(\n)/mg,
	handler: function(w)
	{
		var stack = [w.output];
		var currLevel = 0, currType = null;
		var listLevel, listType, itemType, baseType;
		w.nextMatch = w.matchStart;
		this.lookaheadRegExp.lastIndex = w.nextMatch;
		var lookaheadMatch = this.lookaheadRegExp.exec(w.source);
		while(lookaheadMatch && lookaheadMatch.index == w.nextMatch) {
			if(lookaheadMatch[1]) {
				listType = "ul";
				itemType = "li";
			} else if(lookaheadMatch[2]) {
				listType = "ol";
				itemType = "li";
			} else if(lookaheadMatch[3]) {
				listType = "dl";
				itemType = "dt";
			} else if(lookaheadMatch[4]) {
				listType = "dl";
				itemType = "dd";
			}
			if(!baseType)
				baseType = listType;
			listLevel = lookaheadMatch[0].length;
			w.nextMatch += lookaheadMatch[0].length;
			var t;
			if(listLevel > currLevel) {
				for(t=currLevel; t<listLevel; t++) {
					var target = (currLevel == 0) ? stack[stack.length-1] : stack[stack.length-1].lastChild;
					stack.push(createTiddlyElement(target,listType));
				}
			} else if(listType!=baseType && listLevel==1) {
				w.nextMatch -= lookaheadMatch[0].length;
				return;
			} else if(listLevel < currLevel) {
				for(t=currLevel; t>listLevel; t--)
					stack.pop();
			} else if(listLevel == currLevel && listType != currType) {
				stack.pop();
				stack.push(createTiddlyElement(stack[stack.length-1].lastChild,listType));
			}
			currLevel = listLevel;
			currType = listType;
			var e = createTiddlyElement(stack[stack.length-1],itemType);
			w.subWikifyTerm(e,this.termRegExp);
			this.lookaheadRegExp.lastIndex = w.nextMatch;
			lookaheadMatch = this.lookaheadRegExp.exec(w.source);
		}
	}
},

{
	name: "quoteByBlock",
	match: "^<<<\\n",
	termRegExp: /(^<<<(\n|$))/mg,
	element: "blockquote",
	handler: config.formatterHelpers.createElementAndWikify
},

{
	name: "quoteByLine",
	match: "^>+",
	lookaheadRegExp: /^>+/mg,
	termRegExp: /(\n)/mg,
	element: "blockquote",
	handler: function(w)
	{
		var stack = [w.output];
		var currLevel = 0;
		var newLevel = w.matchLength;
		var t;
		do {
			if(newLevel > currLevel) {
				for(t=currLevel; t<newLevel; t++)
					stack.push(createTiddlyElement(stack[stack.length-1],this.element));
			} else if(newLevel < currLevel) {
				for(t=currLevel; t>newLevel; t--)
					stack.pop();
			}
			currLevel = newLevel;
			w.subWikifyTerm(stack[stack.length-1],this.termRegExp);
			createTiddlyElement(stack[stack.length-1],"br");
			this.lookaheadRegExp.lastIndex = w.nextMatch;
			var lookaheadMatch = this.lookaheadRegExp.exec(w.source);
			var matched = lookaheadMatch && lookaheadMatch.index == w.nextMatch;
			if(matched) {
				newLevel = lookaheadMatch[0].length;
				w.nextMatch += lookaheadMatch[0].length;
			}
		} while(matched);
	}
},

{
	name: "rule",
	match: "^----+$\\n?",
	handler: function(w)
	{
		createTiddlyElement(w.output,"hr");
	}
},

{
	name: "monospacedByLine",
	match: "^(?:/\\*\\{\\{\\{\\*/|\\{\\{\\{|//\\{\\{\\{|<!--\\{\\{\\{-->)\\n",
	element: "pre",
	handler: function(w)
	{
		switch(w.matchText) {
		case "/*{{{*/\n": // CSS
			this.lookaheadRegExp = /\/\*\{\{\{\*\/\n*((?:^[^\n]*\n)+?)(\n*^\/\*\}\}\}\*\/$\n?)/mg;
			break;
		case "{{{\n": // monospaced block
			this.lookaheadRegExp = /^\{\{\{\n((?:^[^\n]*\n)+?)(^\}\}\}$\n?)/mg;
			break;
		case "//{{{\n": // plugin
			this.lookaheadRegExp = /^\/\/\{\{\{\n\n*((?:^[^\n]*\n)+?)(\n*^\/\/\}\}\}$\n?)/mg;
			break;
		case "<!--{{{-->\n": //template
			this.lookaheadRegExp = /<!--\{\{\{-->\n*((?:^[^\n]*\n)+?)(\n*^<!--\}\}\}-->$\n?)/mg;
			break;
		default:
			break;
		}
		config.formatterHelpers.enclosedTextHelper.call(this,w);
	}
},

{
	name: "wikifyComment",
	match: "^(?:/\\*\\*\\*|<!---)\\n",
	handler: function(w)
	{
		var termRegExp = (w.matchText == "/***\n") ? (/(^\*\*\*\/\n)/mg) : (/(^--->\n)/mg);
		w.subWikifyTerm(w.output,termRegExp);
	}
},

{
	name: "macro",
	match: "<<",
	lookaheadRegExp: /<<([^>\s]+)(?:\s*)((?:[^>]|(?:>(?!>)))*)>>/mg,
	handler: function(w)
	{
		this.lookaheadRegExp.lastIndex = w.matchStart;
		var lookaheadMatch = this.lookaheadRegExp.exec(w.source);
		if(lookaheadMatch && lookaheadMatch.index == w.matchStart && lookaheadMatch[1]) {
			w.nextMatch = this.lookaheadRegExp.lastIndex;
			invokeMacro(w.output,lookaheadMatch[1],lookaheadMatch[2],w,w.tiddler);
		}
	}
},

{
	name: "prettyLink",
	match: "\\[\\[",
	lookaheadRegExp: /\[\[(.*?)(?:\|(~)?(.*?))?\]\]/mg,
	handler: function(w)
	{
		this.lookaheadRegExp.lastIndex = w.matchStart;
		var lookaheadMatch = this.lookaheadRegExp.exec(w.source);
		if(lookaheadMatch && lookaheadMatch.index == w.matchStart) {
			var e;
			var text = lookaheadMatch[1];
			if(lookaheadMatch[3]) {
				// Pretty bracketted link
				var link = lookaheadMatch[3];
				e = (!lookaheadMatch[2] && config.formatterHelpers.isExternalLink(link)) ?
						createExternalLink(w.output,link) : createTiddlyLink(w.output,link,false,null,w.isStatic,w.tiddler);
			} else {
				// Simple bracketted link
				e = createTiddlyLink(w.output,text,false,null,w.isStatic,w.tiddler);
			}
			createTiddlyText(e,text);
			w.nextMatch = this.lookaheadRegExp.lastIndex;
		}
	}
},

{
	name: "prettyNamespaceLink",
	match: config.textPrimitives.anyLetter + "+\\:\\:" + config.textPrimitives.anyLetter + "*",
	handler: function(w)
	{
		separated = w.matchText.split("::");
		//debug("achei namespaceLink: " + w.matchText.length);

		var linkQuery = "?namespace=" +  separated[0];
		if (separated[1]) {
			linkQuery = linkQuery + "#" + separated[1]
		}
		e = createExternalLink(w.output,linkQuery);

		w.outputText(e, w.matchStart, w.matchStart + w.matchText.length);
		//w.nextMatch = lookaheadMatch.index + lookaheadMatch[0].length;
	}
},

{
	name: "wikiLink",
	match: config.textPrimitives.unWikiLink+"?"+config.textPrimitives.wikiLink,
	handler: function(w)
	{
		if(w.matchText.substr(0,1) == config.textPrimitives.unWikiLink) {
			w.outputText(w.output,w.matchStart+1,w.nextMatch);
			return;
		}
		if(w.matchStart > 0) {
			var preRegExp = new RegExp(config.textPrimitives.anyLetterStrict,"mg");
			preRegExp.lastIndex = w.matchStart-1;
			var preMatch = preRegExp.exec(w.source);
			if(preMatch.index == w.matchStart-1) {
				w.outputText(w.output,w.matchStart,w.nextMatch);
				return;
			}
		}
		if(w.autoLinkWikiWords || store.isShadowTiddler(w.matchText)) {
			var link = createTiddlyLink(w.output,w.matchText,false,null,w.isStatic,w.tiddler);
			w.outputText(link,w.matchStart,w.nextMatch);
		} else {
			w.outputText(w.output,w.matchStart,w.nextMatch);
		}
	}
},

{
	name: "urlLink",
	match: config.textPrimitives.urlPattern,
	handler: function(w)
	{
		w.outputText(createExternalLink(w.output,w.matchText),w.matchStart,w.nextMatch);
	}
},

{
	name: "image",
	match: "\\[[<>]?[Ii][Mm][Gg]\\[",
	lookaheadRegExp: /\[([<]?)(>?)[Ii][Mm][Gg]\[(?:([^\|\]]+)\|)?([^\[\]\|]+)\](?:\[([^\]]*)\])?\]/mg,
	handler: function(w)
	{
		this.lookaheadRegExp.lastIndex = w.matchStart;
		var lookaheadMatch = this.lookaheadRegExp.exec(w.source);
		if(lookaheadMatch && lookaheadMatch.index == w.matchStart) {
			var e = w.output;
			if(lookaheadMatch[5]) {
				var link = lookaheadMatch[5];
				e = config.formatterHelpers.isExternalLink(link) ? createExternalLink(w.output,link) : createTiddlyLink(w.output,link,false,null,w.isStatic,w.tiddler);
				addClass(e,"imageLink");
			}
			var img = createTiddlyElement(e,"img");
			if(lookaheadMatch[1])
				img.align = "left";
			else if(lookaheadMatch[2])
				img.align = "right";
			if(lookaheadMatch[3])
				img.title = lookaheadMatch[3];
			img.src = lookaheadMatch[4];
			w.nextMatch = this.lookaheadRegExp.lastIndex;
		}
	}
},

{
	name: "html",
	match: "<[Hh][Tt][Mm][Ll]>",
	lookaheadRegExp: /<[Hh][Tt][Mm][Ll]>((?:.|\n)*?)<\/[Hh][Tt][Mm][Ll]>/mg,
	handler: function(w)
	{
		this.lookaheadRegExp.lastIndex = w.matchStart;
		var lookaheadMatch = this.lookaheadRegExp.exec(w.source);
		if(lookaheadMatch && lookaheadMatch.index == w.matchStart) {
			createTiddlyElement(w.output,"span").innerHTML = lookaheadMatch[1];
			w.nextMatch = this.lookaheadRegExp.lastIndex;
		}
	}
},

{
	name: "commentByBlock",
	match: "/%",
	lookaheadRegExp: /\/%((?:.|\n)*?)%\//mg,
	handler: function(w)
	{
		this.lookaheadRegExp.lastIndex = w.matchStart;
		var lookaheadMatch = this.lookaheadRegExp.exec(w.source);
		if(lookaheadMatch && lookaheadMatch.index == w.matchStart)
			w.nextMatch = this.lookaheadRegExp.lastIndex;
	}
},

{
	name: "characterFormat",
	match: "''|//|__|\\^\\^|~~|--(?!\\s|$)|\\{\\{\\{",
	handler: function(w)
	{
		switch(w.matchText) {
		case "''":
			w.subWikifyTerm(w.output.appendChild(document.createElement("strong")),/('')/mg);
			break;
		case "//":
			w.subWikifyTerm(createTiddlyElement(w.output,"em"),/(\/\/)/mg);
			break;
		case "__":
			w.subWikifyTerm(createTiddlyElement(w.output,"u"),/(__)/mg);
			break;
		case "^^":
			w.subWikifyTerm(createTiddlyElement(w.output,"sup"),/(\^\^)/mg);
			break;
		case "~~":
			w.subWikifyTerm(createTiddlyElement(w.output,"sub"),/(~~)/mg);
			break;
		case "--":
			w.subWikifyTerm(createTiddlyElement(w.output,"strike"),/(--)/mg);
			break;
		case "{{{":
			var lookaheadRegExp = /\{\{\{((?:.|\n)*?)\}\}\}/mg;
			lookaheadRegExp.lastIndex = w.matchStart;
			var lookaheadMatch = lookaheadRegExp.exec(w.source);
			if(lookaheadMatch && lookaheadMatch.index == w.matchStart) {
				createTiddlyElement(w.output,"code",null,null,lookaheadMatch[1]);
				w.nextMatch = lookaheadRegExp.lastIndex;
			}
			break;
		}
	}
},

{
	name: "customFormat",
	match: "@@|\\{\\{",
	handler: function(w)
	{
		switch(w.matchText) {
		case "@@":
			var e = createTiddlyElement(w.output,"span");
			var styles = config.formatterHelpers.inlineCssHelper(w);
			if(styles.length == 0)
				e.className = "marked";
			else
				config.formatterHelpers.applyCssHelper(e,styles);
			w.subWikifyTerm(e,/(@@)/mg);
			break;
		case "{{":
			lookaheadRegExp = /\{\{[\s]*([\w]+[\s\w]*)[\s]*\{(\n?)/mg;
			lookaheadRegExp.lastIndex = w.matchStart;
			lookaheadMatch = lookaheadRegExp.exec(w.source);
			if(lookaheadMatch) {
				w.nextMatch = lookaheadRegExp.lastIndex;
				e = createTiddlyElement(w.output,lookaheadMatch[2] == "\n" ? "div" : "span",null,lookaheadMatch[1]);
				w.subWikifyTerm(e,/(\}\}\})/mg);
			}
			break;
		}
	}
},

{
	name: "mdash",
	match: "--",
	handler: function(w)
	{
		createTiddlyElement(w.output,"span").innerHTML = "&mdash;";
	}
},

{
	name: "lineBreak",
	match: "\\n|<br ?/?>",
	handler: function(w)
	{
		createTiddlyElement(w.output,"br");
	}
},

{
	name: "rawText",
	match: "\\\"{3}|<nowiki>",
	lookaheadRegExp: /(?:\"{3}|<nowiki>)((?:.|\n)*?)(?:\"{3}|<\/nowiki>)/mg,
	handler: function(w)
	{
		this.lookaheadRegExp.lastIndex = w.matchStart;
		var lookaheadMatch = this.lookaheadRegExp.exec(w.source);
		if(lookaheadMatch && lookaheadMatch.index == w.matchStart) {
			createTiddlyElement(w.output,"span",null,null,lookaheadMatch[1]);
			w.nextMatch = this.lookaheadRegExp.lastIndex;
		}
	}
},

{
	name: "htmlEntitiesEncoding",
	match: "(?:(?:&#?[a-zA-Z0-9]{2,8};|.)(?:&#?(?:x0*(?:3[0-6][0-9a-fA-F]|1D[c-fC-F][0-9a-fA-F]|20[d-fD-F][0-9a-fA-F]|FE2[0-9a-fA-F])|0*(?:76[89]|7[7-9][0-9]|8[0-7][0-9]|761[6-9]|76[2-7][0-9]|84[0-3][0-9]|844[0-7]|6505[6-9]|6506[0-9]|6507[0-1]));)+|&#?[a-zA-Z0-9]{2,8};)",
	handler: function(w)
	{
		createTiddlyElement(w.output,"span").innerHTML = w.matchText;
	}
}

];

//--
//-- Wikifier
//--

function getParser(tiddler,format)
{
	if(tiddler) {
		if(!format)
			format = tiddler.fields["wikiformat"];
		var i;
		if(format) {
			for(i in config.parsers) {
				if(format == config.parsers[i].format)
					return config.parsers[i];
			}
		} else {
			for(i in config.parsers) {
				if(tiddler.isTagged(config.parsers[i].formatTag))
					return config.parsers[i];
			}
		}
	}
	return formatter;
}

function wikify(source,output,highlightRegExp,tiddler)
{
	if(source && source != "") {
		var wikifier = new Wikifier(source,getParser(tiddler),highlightRegExp,tiddler);
		wikifier.subWikifyUnterm(output);
	}
}

function wikifyStatic(source,highlightRegExp,tiddler,format)
{
	var e = createTiddlyElement(document.body,"div");
	e.style.display = "none";
	var html = "";
	if(source && source != "") {
		var wikifier = new Wikifier(source,getParser(tiddler,format),highlightRegExp,tiddler);
		wikifier.isStatic = true;
		wikifier.subWikifyUnterm(e);
		html = e.innerHTML;
		removeNode(e);
	}
	return html;
}

function wikifyPlain(title,theStore,limit)
{
	if(!theStore)
		theStore = store;
	if(theStore.tiddlerExists(title) || theStore.isShadowTiddler(title)) {
		return wikifyPlainText(theStore.getTiddlerText(title),limit,tiddler);
	} else {
		return "";
	}
}

function wikifyPlainText(text,limit,tiddler)
{
	if(limit > 0)
		text = text.substr(0,limit);
	var wikifier = new Wikifier(text,formatter,null,tiddler);
	return wikifier.wikifyPlain();
}

function highlightify(source,output,highlightRegExp,tiddler)
{
	if(source && source != "") {
		var wikifier = new Wikifier(source,formatter,highlightRegExp,tiddler);
		wikifier.outputText(output,0,source.length);
	}
}

function Wikifier(source,formatter,highlightRegExp,tiddler)
{
	this.source = source;
	this.output = null;
	this.formatter = formatter;
	this.nextMatch = 0;
	this.autoLinkWikiWords = tiddler && tiddler.autoLinkWikiWords() == false ? false : true;
	this.highlightRegExp = highlightRegExp;
	this.highlightMatch = null;
	this.isStatic = false;
	if(highlightRegExp) {
		highlightRegExp.lastIndex = 0;
		this.highlightMatch = highlightRegExp.exec(source);
	}
	this.tiddler = tiddler;
}

Wikifier.prototype.wikifyPlain = function()
{
	var e = createTiddlyElement(document.body,"div");
	this.subWikify(e);
	var text = getPlainText(e);
	removeNode(e);
	return text;
};

Wikifier.prototype.subWikify = function(output,terminator)
{
	if(terminator)
		this.subWikifyTerm(output,new RegExp("(" + terminator + ")","mg"));
	else
		this.subWikifyUnterm(output);
};

Wikifier.prototype.subWikifyUnterm = function(output)
{
	var oldOutput = this.output;
	this.output = output;
	this.formatter.formatterRegExp.lastIndex = this.nextMatch;
	var formatterMatch = this.formatter.formatterRegExp.exec(this.source);
	while(formatterMatch) {
		// Output any text before the match
		if(formatterMatch.index > this.nextMatch)
			this.outputText(this.output,this.nextMatch,formatterMatch.index);
		// Set the match parameters for the handler
		this.matchStart = formatterMatch.index;
		this.matchLength = formatterMatch[0].length;
		this.matchText = formatterMatch[0];
		this.nextMatch = this.formatter.formatterRegExp.lastIndex;
		for(var t=1; t<formatterMatch.length; t++) {
			if(formatterMatch[t]) {
				this.formatter.formatters[t-1].handler(this);
				this.formatter.formatterRegExp.lastIndex = this.nextMatch;
				break;
			}
		}
		formatterMatch = this.formatter.formatterRegExp.exec(this.source);
	}
	if(this.nextMatch < this.source.length) {
		this.outputText(this.output,this.nextMatch,this.source.length);
		this.nextMatch = this.source.length;
	}
	this.output = oldOutput;
};

Wikifier.prototype.subWikifyTerm = function(output,terminatorRegExp)
{
	var oldOutput = this.output;
	this.output = output;
	terminatorRegExp.lastIndex = this.nextMatch;
	var terminatorMatch = terminatorRegExp.exec(this.source);
	this.formatter.formatterRegExp.lastIndex = this.nextMatch;
	var formatterMatch = this.formatter.formatterRegExp.exec(terminatorMatch ? this.source.substr(0,terminatorMatch.index) : this.source);
	while(terminatorMatch || formatterMatch) {
		if(terminatorMatch && (!formatterMatch || terminatorMatch.index <= formatterMatch.index)) {
			if(terminatorMatch.index > this.nextMatch)
				this.outputText(this.output,this.nextMatch,terminatorMatch.index);
			this.matchText = terminatorMatch[1];
			this.matchLength = terminatorMatch[1].length;
			this.matchStart = terminatorMatch.index;
			this.nextMatch = this.matchStart + this.matchLength;
			this.output = oldOutput;
			return;
		}
		if(formatterMatch.index > this.nextMatch)
			this.outputText(this.output,this.nextMatch,formatterMatch.index);
		this.matchStart = formatterMatch.index;
		this.matchLength = formatterMatch[0].length;
		this.matchText = formatterMatch[0];
		this.nextMatch = this.formatter.formatterRegExp.lastIndex;
		for(var t=1; t<formatterMatch.length; t++) {
			if(formatterMatch[t]) {
				this.formatter.formatters[t-1].handler(this);
				this.formatter.formatterRegExp.lastIndex = this.nextMatch;
				break;
			}
		}
		terminatorRegExp.lastIndex = this.nextMatch;
		terminatorMatch = terminatorRegExp.exec(this.source);
		formatterMatch = this.formatter.formatterRegExp.exec(terminatorMatch ? this.source.substr(0,terminatorMatch.index) : this.source);
	}
	if(this.nextMatch < this.source.length) {
		this.outputText(this.output,this.nextMatch,this.source.length);
		this.nextMatch = this.source.length;
	}
	this.output = oldOutput;
};

Wikifier.prototype.outputText = function(place,startPos,endPos)
{
	while(this.highlightMatch && (this.highlightRegExp.lastIndex > startPos) && (this.highlightMatch.index < endPos) && (startPos < endPos)) {
		if(this.highlightMatch.index > startPos) {
			createTiddlyText(place,this.source.substring(startPos,this.highlightMatch.index));
			startPos = this.highlightMatch.index;
		}
		var highlightEnd = Math.min(this.highlightRegExp.lastIndex,endPos);
		var theHighlight = createTiddlyElement(place,"span",null,"highlight",this.source.substring(startPos,highlightEnd));
		startPos = highlightEnd;
		if(startPos >= this.highlightRegExp.lastIndex)
			this.highlightMatch = this.highlightRegExp.exec(this.source);
	}
	if(startPos < endPos) {
		createTiddlyText(place,this.source.substring(startPos,endPos));
	}
};

//--
//-- Macro definitions
//--

config.macros.today.handler = function(place,macroName,params)
{
	var now = new Date();
	var text = params[0] ? now.formatString(params[0].trim()) : text = now.toLocaleString();
	createTiddlyElement(place,"span",null,null,text);
};

config.macros.version.handler = function(place)
{
	createTiddlyElement(place,"span",null,null,version.major + "." + version.minor + "." + version.revision + (version.beta ? " (beta " + version.beta + ")" : ""));
};

config.macros.list.handler = function(place,macroName,params)
{
	var type = params[0] ? params[0] : "all";
	var list = document.createElement("ul");
	place.appendChild(list);
	if(this[type].prompt)
		createTiddlyElement(list,"li",null,"listTitle",this[type].prompt);
	var results;
	if(this[type].handler)
		results = this[type].handler(params);
	for(var t = 0; t < results.length; t++) {
		var li = document.createElement("li");
		list.appendChild(li);
		createTiddlyLink(li,typeof results[t] == "string" ? results[t] : results[t].title,true);
	}
};

config.macros.list.all.handler = function(params)
{
	return store.reverseLookup("tags","excludeLists",false,"title");
};

config.macros.list.missing.handler = function(params)
{
	return store.getMissingLinks();
};

config.macros.list.orphans.handler = function(params)
{
	return store.getOrphans();
};

config.macros.list.shadowed.handler = function(params)
{
	return store.getShadowed();
};

config.macros.list.touched.handler = function(params)
{
	return store.getTouched();
};

config.macros.list.filter.handler = function(params)
{
	var filter = params[1];
	var results = [];
	if(filter) {
		var tiddlers = store.filterTiddlers(filter);
		for(var t=0; t<tiddlers.length; t++)
			results.push(tiddlers[t].title);
	}
	return results;
};

config.macros.allTags.handler = function(place,macroName,params)
{
	var tags = store.getTags(params[0]);
	var ul = createTiddlyElement(place,"ul");
	if(tags.length == 0)
		createTiddlyElement(ul,"li",null,"listTitle",this.noTags);
	for(var t=0; t<tags.length; t++) {
		var title = tags[t][0];
		var info = getTiddlyLinkInfo(title);
		var li =createTiddlyElement(ul,"li");
		var btn = createTiddlyButton(li,title + " (" + tags[t][1] + ")",this.tooltip.format([title]),onClickTag,info.classes);
		btn.setAttribute("tag",title);
		btn.setAttribute("refresh","link");
		btn.setAttribute("tiddlyLink",title);
	}
};

config.macros.timeline.handler = function(place,macroName,params)
{
	var field = params[0] ? params[0] : "modified";
	var tiddlers = store.reverseLookup("tags","excludeLists",false,field);
	var lastDay = "";
	var last = params[1] ? tiddlers.length-Math.min(tiddlers.length,parseInt(params[1])) : 0;
	var dateFormat = params[2] ? params[2] : this.dateFormat;
	for(var t=tiddlers.length-1; t>=last; t--) {
		var tiddler = tiddlers[t];
		var theDay = tiddler[field].convertToLocalYYYYMMDDHHMM().substr(0,8);
		if(theDay != lastDay) {
			var ul = document.createElement("ul");
			place.appendChild(ul);
			createTiddlyElement(ul,"li",null,"listTitle",tiddler[field].formatString(dateFormat));
			lastDay = theDay;
		}
		createTiddlyElement(ul,"li",null,"listLink").appendChild(createTiddlyLink(place,tiddler.title,true));
	}
};

config.macros.tiddler.handler = function(place,macroName,params,wikifier,paramString,tiddler)
{
	params = paramString.parseParams("name",null,true,false,true);
	var names = params[0]["name"];
	var tiddlerName = names[0];
	var className = names[1] ? names[1] : null;
	var args = params[0]["with"];
	var wrapper = createTiddlyElement(place,"span",null,className);
	if(!args) {
		wrapper.setAttribute("refresh","content");
		wrapper.setAttribute("tiddler",tiddlerName);
	}
	var text = store.getTiddlerText(tiddlerName);
	if(text) {
		var stack = config.macros.tiddler.tiddlerStack;
		if(stack.indexOf(tiddlerName) !== -1)
			return;
		stack.push(tiddlerName);
		try {
			var n = args ? Math.min(args.length,9) : 0;
			for(var i=0; i<n; i++) {
				var placeholderRE = new RegExp("\\$" + (i + 1),"mg");
				text = text.replace(placeholderRE,args[i]);
			}
			config.macros.tiddler.renderText(wrapper,text,tiddlerName,params);
		} finally {
			stack.pop();
		}
	}
};

config.macros.tiddler.renderText = function(place,text,tiddlerName,params)
{
	wikify(text,place,null,store.getTiddler(tiddlerName));
};

config.macros.tiddler.tiddlerStack = [];

config.macros.tag.handler = function(place,macroName,params)
{
	createTagButton(place,params[0]);
};

config.macros.tags.handler = function(place,macroName,params,wikifier,paramString,tiddler)
{
	params = paramString.parseParams("anon",null,true,false,false);
	var ul = createTiddlyElement(place,"ul");
	var title = getParam(params,"anon","");
	if(title && store.tiddlerExists(title))
		tiddler = store.getTiddler(title);
	var sep = getParam(params,"sep"," ");
	var lingo = config.views.wikified.tag;
	var prompt = tiddler.tags.length == 0 ? lingo.labelNoTags : lingo.labelTags;
	createTiddlyElement(ul,"li",null,"listTitle",prompt.format([tiddler.title]));
	for(var t=0; t<tiddler.tags.length; t++) {
		createTagButton(createTiddlyElement(ul,"li"),tiddler.tags[t],tiddler.title);
		if(t<tiddler.tags.length-1)
			createTiddlyText(ul,sep);
	}
};

config.macros.tagging.handler = function(place,macroName,params,wikifier,paramString,tiddler)
{
	params = paramString.parseParams("anon",null,true,false,false);
	var ul = createTiddlyElement(place,"ul");
	var title = getParam(params,"anon","");
	if(title == "" && tiddler instanceof Tiddler)
		title = tiddler.title;
	var sep = getParam(params,"sep"," ");
	ul.setAttribute("title",this.tooltip.format([title]));
	var tagged = store.getTaggedTiddlers(title);
	var prompt = tagged.length == 0 ? this.labelNotTag : this.label;
	createTiddlyElement(ul,"li",null,"listTitle",prompt.format([title,tagged.length]));
	for(var t=0; t<tagged.length; t++) {
		createTiddlyLink(createTiddlyElement(ul,"li"),tagged[t].title,true);
		if(t<tagged.length-1)
			createTiddlyText(ul,sep);
	}
};

config.macros.closeAll.handler = function(place)
{
	createTiddlyButton(place,this.label,this.prompt,this.onClick);
};

config.macros.closeAll.onClick = function(e)
{
	story.closeAllTiddlers();
	return false;
};

config.macros.permaview.handler = function(place)
{
	createTiddlyButton(place,this.label,this.prompt,this.onClick);
};

config.macros.permaview.onClick = function(e)
{
	story.permaView();
	return false;
};

config.macros.saveChanges.handler = function(place)
{
	if(!readOnly)
		createTiddlyButton(place,this.label,this.prompt,this.onClick,null,null,this.accessKey);
};

config.macros.saveChanges.onClick = function(e)
{
	saveChanges();
	return false;
};

config.macros.slider.onClickSlider = function(ev)
{
	var e = ev ? ev : window.event;
	var n = this.nextSibling;
	var cookie = n.getAttribute("cookie");
	var isOpen = n.style.display != "none";
	if(config.options.chkAnimate && anim && typeof Slider == "function")
		anim.startAnimating(new Slider(n,!isOpen,null,"none"));
	else
		n.style.display = isOpen ? "none" : "block";
	config.options[cookie] = !isOpen;
	saveOptionCookie(cookie);
	return false;
};

config.macros.slider.createSlider = function(place,cookie,title,tooltip)
{
	var c = cookie ? cookie : "";
	var btn = createTiddlyButton(place,title,tooltip,this.onClickSlider);
	var panel = createTiddlyElement(null,"div",null,"sliderPanel");
	panel.setAttribute("cookie",c);
	panel.style.display = config.options[c] ? "block" : "none";
	place.appendChild(panel);
	return panel;
};

config.macros.slider.handler = function(place,macroName,params)
{
	var panel = this.createSlider(place,params[0],params[2],params[3]);
	var text = store.getTiddlerText(params[1]);
	panel.setAttribute("refresh","content");
	panel.setAttribute("tiddler",params[1]);
	if(text)
		wikify(text,panel,null,store.getTiddler(params[1]));
};

// <<gradient [[tiddler name]] vert|horiz rgb rgb rgb rgb... >>
config.macros.gradient.handler = function(place,macroName,params,wikifier)
{
	var panel = wikifier ? createTiddlyElement(place,"div",null,"gradient") : place;
	panel.style.position = "relative";
	panel.style.overflow = "hidden";
	panel.style.zIndex = "0";
	if(wikifier) {
		var styles = config.formatterHelpers.inlineCssHelper(wikifier);
		config.formatterHelpers.applyCssHelper(panel,styles);
	}
	var colours = [];
	for(var t=1; t<params.length; t++) {
		var c = new RGB(params[t]);
		if(c)
			colours.push(c);
	}
	drawGradient(panel,params[0] != "vert",colours);
	if(wikifier)
		wikifier.subWikify(panel,">>");
	if(document.all) {
		panel.style.height = "100%";
		panel.style.width = "100%";
	}
};

config.macros.message.handler = function(place,macroName,params)
{
	if(params[0]) {
		var m = config;
		var p = params[0].split(".");
		for(var t=0; t<p.length; t++) {
			if(p[t] in m)
				m = m[p[t]];
			else
				break;
		}
		createTiddlyText(place,m.toString().format(params.splice(1)));
	}
};

config.macros.view.handler = function(place,macroName,params,wikifier,paramString,tiddler)
{
	if((tiddler instanceof Tiddler) && params[0]) {
		var value = store.getValue(tiddler,params[0]);
		if(value != undefined) {
			switch(params[1]) {
				case undefined:
					highlightify(value,place,highlightHack,tiddler);
					break;
				case "link":
					createTiddlyLink(place,value,true);
					break;
				case "wikified":
					wikify(value,place,highlightHack,tiddler);
					break;
				case "date":
					value = Date.convertFromYYYYMMDDHHMM(value);
					createTiddlyText(place,value.formatString(params[2] ? params[2] : config.views.wikified.dateFormat));
					break;
			}
		}
	}
};

config.macros.edit.handler = function(place,macroName,params,wikifier,paramString,tiddler)
{
	var field = params[0];
	var rows = params[1] || 0;
	var defVal = params[2] || '';
	if((tiddler instanceof Tiddler) && field) {
		story.setDirty(tiddler.title,true);
		var e,v;
		if(field != "text" && !rows) {
			e = createTiddlyElement(null,"input");
			if(tiddler.isReadOnly())
				e.setAttribute("readOnly","readOnly");
			e.setAttribute("edit",field);
			e.setAttribute("type","text");
			e.value = store.getValue(tiddler,field) || defVal;
			e.setAttribute("size","40");
			e.setAttribute("autocomplete","off");
			place.appendChild(e);
		} else {
			var wrapper1 = createTiddlyElement(null,"fieldset",null,"fieldsetFix");
			var wrapper2 = createTiddlyElement(wrapper1,"div");
			e = createTiddlyElement(wrapper2,"textarea");
			if(tiddler.isReadOnly())
				e.setAttribute("readOnly","readOnly");
			e.value = v = store.getValue(tiddler,field) || defVal;
			rows = rows ? rows : 10;
			var lines = v.match(/\n/mg);
			var maxLines = Math.max(parseInt(config.options.txtMaxEditRows),5);
			if(lines != null && lines.length > rows)
				rows = lines.length + 5;
			rows = Math.min(rows,maxLines);
			e.setAttribute("rows",rows);
			e.setAttribute("edit",field);
			place.appendChild(wrapper1);
		}
		return e;
	}
};

config.macros.tagChooser.onClick = function(ev)
{
	var e = ev ? ev : window.event;
	var lingo = config.views.editor.tagChooser;
	var popup = Popup.create(this);
	var tags = store.getTags();
	if(tags.length == 0)
		createTiddlyText(createTiddlyElement(popup,"li"),lingo.popupNone);
	for(var t=0; t<tags.length; t++) {
		var tag = createTiddlyButton(createTiddlyElement(popup,"li"),tags[t][0],lingo.tagTooltip.format([tags[t][0]]),config.macros.tagChooser.onTagClick);
		tag.setAttribute("tag",tags[t][0]);
		tag.setAttribute("tiddler",this.getAttribute("tiddler"));
	}
	Popup.show();
	e.cancelBubble = true;
	if(e.stopPropagation) e.stopPropagation();
	return false;
};

config.macros.tagChooser.onTagClick = function(ev)
{
	var e = ev ? ev : window.event;
	var tag = this.getAttribute("tag");
	var title = this.getAttribute("tiddler");
	if(!readOnly)
		story.setTiddlerTag(title,tag,0);
	return false;
};

config.macros.tagChooser.handler = function(place,macroName,params,wikifier,paramString,tiddler)
{
	if(tiddler instanceof Tiddler) {
		var lingo = config.views.editor.tagChooser;
		var btn = createTiddlyButton(place,lingo.text,lingo.tooltip,this.onClick);
		btn.setAttribute("tiddler",tiddler.title);
	}
};

config.macros.refreshDisplay.handler = function(place)
{
	createTiddlyButton(place,this.label,this.prompt,this.onClick);
};

config.macros.refreshDisplay.onClick = function(e)
{
	refreshAll();
	return false;
};

config.macros.annotations.handler = function(place,macroName,params,wikifier,paramString,tiddler)
{
	var title = tiddler ? tiddler.title : null;
	var a = title ? config.annotations[title] : null;
	if(!tiddler || !title || !a)
		return;
	var text = a.format([title]);
	wikify(text,createTiddlyElement(place,"div",null,"annotation"),null,tiddler);
};

//--
//-- NewTiddler and NewJournal macros
//--

config.macros.newTiddler.createNewTiddlerButton = function(place,title,params,label,prompt,accessKey,newFocus,isJournal)
{
	var tags = [];
	for(var t=1; t<params.length; t++) {
		if((params[t].name == "anon" && t != 1) || (params[t].name == "tag"))
			tags.push(params[t].value);
	}
	label = getParam(params,"label",label);
	prompt = getParam(params,"prompt",prompt);
	accessKey = getParam(params,"accessKey",accessKey);
	newFocus = getParam(params,"focus",newFocus);
	var customFields = getParam(params,"fields","");
	if(!customFields && !store.isShadowTiddler(title))
		customFields = String.encodeHashMap(config.defaultCustomFields);
	var btn = createTiddlyButton(place,label,prompt,this.onClickNewTiddler,null,null,accessKey);
	btn.setAttribute("newTitle",title);
	btn.setAttribute("isJournal",isJournal ? "true" : "false");
	if(tags.length > 0)
		btn.setAttribute("params",tags.join("|"));
	btn.setAttribute("newFocus",newFocus);
	btn.setAttribute("newTemplate",getParam(params,"template",DEFAULT_EDIT_TEMPLATE));
	if(customFields !== "")
		btn.setAttribute("customFields",customFields);
	var text = getParam(params,"text");
	if(text !== undefined)
		btn.setAttribute("newText",text);
	return btn;
};

config.macros.newTiddler.onClickNewTiddler = function()
{
	var title = this.getAttribute("newTitle");
	if(this.getAttribute("isJournal") == "true") {
		var now = new Date();
		title = now.formatString(title.trim());
	}
	var params = this.getAttribute("params");
	var tags = params ? params.split("|") : [];
	var focus = this.getAttribute("newFocus");
	var template = this.getAttribute("newTemplate");
	var customFields = this.getAttribute("customFields");
	story.displayTiddler(null,title,template,false,null,null);
	var tiddlerElem = document.getElementById(story.idPrefix + title);
	if(customFields)
		story.addCustomFields(tiddlerElem,customFields);
	var text = this.getAttribute("newText");
	if(typeof text == "string")
		story.getTiddlerField(title,"text").value = text.format([title]);
	for(var t=0;t<tags.length;t++)
		story.setTiddlerTag(title,tags[t],+1);
	story.focusTiddler(title,focus);
	return false;
};

config.macros.newTiddler.handler = function(place,macroName,params,wikifier,paramString,tiddler)
{
	if(!readOnly) {
		params = paramString.parseParams("anon",null,true,false,false);
		var title = params[1] && params[1].name == "anon" ? params[1].value : this.title;
		title = getParam(params,"title",title);
		this.createNewTiddlerButton(place,title,params,this.label,this.prompt,this.accessKey,"title",false);
	}
};

config.macros.newJournal.handler = function(place,macroName,params,wikifier,paramString,tiddler)
{
	if(!readOnly) {
		params = paramString.parseParams("anon",null,true,false,false);
		var title = params[1] && params[1].name == "anon" ? params[1].value : config.macros.timeline.dateFormat;
		title = getParam(params,"title",title);
		config.macros.newTiddler.createNewTiddlerButton(place,title,params,this.label,this.prompt,this.accessKey,"text",true);
	}
};

//--
//-- Search macro
//--

config.macros.search.handler = function(place,macroName,params)
{
	var searchTimeout = null;
	var btn = createTiddlyButton(place,this.label,this.prompt,this.onClick);
	var txt = createTiddlyElement(place,"input",null,"txtOptionInput");
	if(params[0])
		txt.value = params[0];
	txt.onkeyup = this.onKeyPress;
	txt.onfocus = this.onFocus;
	txt.setAttribute("size",this.sizeTextbox);
	txt.setAttribute("accessKey",this.accessKey);
	txt.setAttribute("autocomplete","off");
	txt.setAttribute("lastSearchText","");
	if(config.browser.isSafari) {
		txt.setAttribute("type","search");
		txt.setAttribute("results","5");
	} else {
		txt.setAttribute("type","text");
	}
};

// Global because there's only ever one outstanding incremental search timer
config.macros.search.timeout = null;

config.macros.search.doSearch = function(txt)
{
	if(txt.value.length > 0) {
		story.search(txt.value,config.options.chkCaseSensitiveSearch,config.options.chkRegExpSearch);
		txt.setAttribute("lastSearchText",txt.value);
	}
};

config.macros.search.onClick = function(e)
{
	config.macros.search.doSearch(this.nextSibling);
	return false;
};

config.macros.search.onKeyPress = function(ev)
{
	var e = ev ? ev : window.event;
	switch(e.keyCode) {
		case 13: // Ctrl-Enter
		case 10: // Ctrl-Enter on IE PC
			config.macros.search.doSearch(this);
			break;
		case 27: // Escape
			this.value = "";
			clearMessage();
			break;
	}
	if(this.value.length > 2) {
		if(this.value != this.getAttribute("lastSearchText")) {
			if(config.macros.search.timeout)
				clearTimeout(config.macros.search.timeout);
			var txt = this;
			config.macros.search.timeout = setTimeout(function() {config.macros.search.doSearch(txt);},500);
		}
	} else {
		if(config.macros.search.timeout)
			clearTimeout(config.macros.search.timeout);
	}
};

config.macros.search.onFocus = function(e)
{
	this.select();
};

//--
//-- Tabs macro
//--

config.macros.tabs.handler = function(place,macroName,params)
{
	var cookie = params[0];
	var numTabs = (params.length-1)/3;
	var wrapper = createTiddlyElement(null,"div",null,cookie);
	var tabset = createTiddlyElement(wrapper,"div",null,"tabset");
	tabset.setAttribute("cookie",cookie);
	var validTab = false;
	for(var t=0; t<numTabs; t++) {
		var label = params[t*3+1];
		var prompt = params[t*3+2];
		var content = params[t*3+3];
		var tab = createTiddlyButton(tabset,label,prompt,this.onClickTab,"tab tabUnselected");
		tab.setAttribute("tab",label);
		tab.setAttribute("content",content);
		tab.title = prompt;
		if(config.options[cookie] == label)
			validTab = true;
	}
	if(!validTab)
		config.options[cookie] = params[1];
	place.appendChild(wrapper);
	this.switchTab(tabset,config.options[cookie]);
};

config.macros.tabs.onClickTab = function(e)
{
	config.macros.tabs.switchTab(this.parentNode,this.getAttribute("tab"));
	return false;
};

config.macros.tabs.switchTab = function(tabset,tab)
{
	var cookie = tabset.getAttribute("cookie");
	var theTab = null;
	var nodes = tabset.childNodes;
	for(var t=0; t<nodes.length; t++) {
		if(nodes[t].getAttribute && nodes[t].getAttribute("tab") == tab) {
			theTab = nodes[t];
			theTab.className = "tab tabSelected";
		} else {
			nodes[t].className = "tab tabUnselected";
		}
	}
	if(theTab) {
		if(tabset.nextSibling && tabset.nextSibling.className == "tabContents")
			removeNode(tabset.nextSibling);
		var tabContent = createTiddlyElement(null,"div",null,"tabContents");
		tabset.parentNode.insertBefore(tabContent,tabset.nextSibling);
		var contentTitle = theTab.getAttribute("content");
		wikify(store.getTiddlerText(contentTitle),tabContent,null,store.getTiddler(contentTitle));
		if(cookie) {
			config.options[cookie] = tab;
			saveOptionCookie(cookie);
		}
	}
};

//--
//-- Tiddler toolbar
//--

// Create a toolbar command button
config.macros.toolbar.createCommand = function(place,commandName,tiddler,theClass)
{
	if(typeof commandName != "string") {
		var c = null;
		for(var t in config.commands) {
			if(config.commands[t] == commandName)
				c = t;
		}
		commandName = c;
	}
	if((tiddler instanceof Tiddler) && (typeof commandName == "string")) {
		var command = config.commands[commandName];
		if(command.isEnabled ? command.isEnabled(tiddler) : this.isCommandEnabled(command,tiddler)) {
			var text = command.getText ? command.getText(tiddler) : this.getCommandText(command,tiddler);
			var tooltip = command.getTooltip ? command.getTooltip(tiddler) : this.getCommandTooltip(command,tiddler);
			var cmd;
			switch(command.type) {
				case "popup":
					cmd = this.onClickPopup;
					break;
				case "command":
				default:
					cmd = this.onClickCommand;
					break;
			}
			var btn = createTiddlyButton(null,text,tooltip,cmd);
			btn.setAttribute("commandName",commandName);
			btn.setAttribute("tiddler",tiddler.title);
			if(theClass)
				addClass(btn,theClass);
			place.appendChild(btn);
		}
	}
};

config.macros.toolbar.isCommandEnabled = function(command,tiddler)
{
	var title = tiddler.title;
	var ro = tiddler.isReadOnly();
	var shadow = store.isShadowTiddler(title) && !store.tiddlerExists(title);
	return (!ro || (ro && !command.hideReadOnly)) && !(shadow && command.hideShadow);
};

config.macros.toolbar.getCommandText = function(command,tiddler)
{
	return tiddler.isReadOnly() && command.readOnlyText ? command.readOnlyText : command.text;
};

config.macros.toolbar.getCommandTooltip = function(command,tiddler)
{
	return tiddler.isReadOnly() && command.readOnlyTooltip ? command.readOnlyTooltip : command.tooltip;
};

config.macros.toolbar.onClickCommand = function(ev)
{
	var e = ev ? ev : window.event;
	e.cancelBubble = true;
	if (e.stopPropagation) e.stopPropagation();
	var command = config.commands[this.getAttribute("commandName")];
	return command.handler(e,this,this.getAttribute("tiddler"));
};

config.macros.toolbar.onClickPopup = function(ev)
{
	var e = ev ? ev : window.event;
	e.cancelBubble = true;
	if (e.stopPropagation) e.stopPropagation();
	var popup = Popup.create(this);
	var command = config.commands[this.getAttribute("commandName")];
	var title = this.getAttribute("tiddler");
	var tiddler = store.fetchTiddler(title);
	popup.setAttribute("tiddler",title);
	command.handlePopup(popup,title);
	Popup.show();
	return false;
};

// Invoke the first command encountered from a given place that is tagged with a specified class
config.macros.toolbar.invokeCommand = function(place,theClass,event)
{
	var children = place.getElementsByTagName("a");
	for(var t=0; t<children.length; t++) {
		var c = children[t];
		if(hasClass(c,theClass) && c.getAttribute && c.getAttribute("commandName")) {
			if(c.onclick instanceof Function)
				c.onclick.call(c,event);
			break;
		}
	}
};

config.macros.toolbar.onClickMore = function(ev)
{
	var e = this.nextSibling;
	e.style.display = "inline";
	removeNode(this);
	return false;
};

config.macros.toolbar.handler = function(place,macroName,params,wikifier,paramString,tiddler)
{
	for(var t=0; t<params.length; t++) {
		var c = params[t];
		switch(c) {
			case '>':
				var btn = createTiddlyButton(place,this.moreLabel,this.morePrompt,config.macros.toolbar.onClickMore);
				addClass(btn,"moreCommand");
				var e = createTiddlyElement(place,"span",null,"moreCommand");
				e.style.display = "none";
				place = e;
				break;
			default:
				var theClass = "";
				switch(c.substr(0,1)) {
					case "+":
						theClass = "defaultCommand";
						c = c.substr(1);
						break;
					case "-":
						theClass = "cancelCommand";
						c = c.substr(1);
						break;
				}
				if(c in config.commands)
					this.createCommand(place,c,tiddler,theClass);
				break;
		}
	}
};


config.macros.saveChangesOnServer = {
label: "save on server",
prompt:"Saves all the changes on the server",
handler: function(place) {
	if(!readOnly)
		createTiddlyButton(place,this.label,this.prompt,this.onClick,null,null,null);
},
onClick: function () {
	ajax.saveTiddlers(store.changedTiddlers);
}};

config.macros.namespaces = {
handler: function(place) {
	var li;
	var link;
    <c:forEach var="ns" items="${namespaces}">
	li = createTiddlyElement(place,"li");
	link = createExternalLink(li,"?namespace=${ns}");
	createTiddlyText(link, "${ns}");

    </c:forEach>
}};

config.macros.thisNamespace = {
handler: function(place) {
	var h = createTiddlyElement(place,"h2");
	createTiddlyText(h, "${namespace}");
}};



//--
//-- Menu and toolbar commands
//--

config.commands.closeTiddler.handler = function(event,src,title)
{
	story.closeTiddler(title,true);
	return false;
};

config.commands.closeOthers.handler = function(event,src,title)
{
	story.closeAllTiddlers(title);
	return false;
};

config.commands.editTiddler.handler = function(event,src,title)
{
	clearMessage();
	var tiddlerElem = document.getElementById(story.idPrefix + title);
	var fields = tiddlerElem.getAttribute("tiddlyFields");
	story.displayTiddler(null,title,DEFAULT_EDIT_TEMPLATE,false,null,fields);
	story.focusTiddler(title,"text");
	return false;
};

config.commands.saveTiddler.handler = function(event,src,title)
{
	var newTitle = story.saveTiddler(title,event.shiftKey);
	if(newTitle)
		story.displayTiddler(null,newTitle);
	return false;
};

config.commands.cancelTiddler.handler = function(event,src,title)
{
	if(story.hasChanges(title) && !readOnly) {
		if(!confirm(this.warning.format([title])))
			return false;
	}
	story.setDirty(title,false);
	story.displayTiddler(null,title);
	return false;
};

config.commands.deleteTiddler.handler = function(event,src,title)
{
	var deleteIt = true;
	if (config.options.chkConfirmDelete)
		deleteIt = confirm(this.warning.format([title]));
	if (deleteIt) {
		store.removeTiddler(title);
		story.closeTiddler(title,true);
		autoSaveChanges();
	}
	return false;
};

config.commands.permalink.handler = function(event,src,title)
{
	var t = encodeURIComponent(String.encodeTiddlyLink(title));
	if(window.location.hash != t)
		window.location.hash = t;
	return false;
};

config.commands.references.handlePopup = function(popup,title)
{
	var references = store.getReferringTiddlers(title);
	var c = false;
	for(var r=0; r<references.length; r++) {
		if(references[r].title != title && !references[r].isTagged("excludeLists")) {
			createTiddlyLink(createTiddlyElement(popup,"li"),references[r].title,true);
			c = true;
		}
	}
	if(!c)
		createTiddlyText(createTiddlyElement(popup,"li",null,"disabled"),this.popupNone);
};

config.commands.jump.handlePopup = function(popup,title)
{
	story.forEachTiddler(function(title,element) {
		createTiddlyLink(createTiddlyElement(popup,"li"),title,true,null,false,null,true);
		});
};

config.commands.syncing.handlePopup = function(popup,title)
{
	var tiddler = store.fetchTiddler(title);
	if(!tiddler)
		return;
	var serverType = tiddler.getServerType();
	var serverHost = tiddler.fields['server.host'];
	var serverWorkspace = tiddler.fields['server.workspace'];
	if(!serverWorkspace)
		serverWorkspace = "";
	if(serverType) {
		var e = createTiddlyElement(popup,"li",null,"popupMessage");
		e.innerHTML = config.commands.syncing.currentlySyncing.format([serverType,serverHost,serverWorkspace]);
	} else {
		createTiddlyElement(popup,"li",null,"popupMessage",config.commands.syncing.notCurrentlySyncing);
	}
	if(serverType) {
		createTiddlyElement(createTiddlyElement(popup,"li",null,"listBreak"),"div");
		var btn = createTiddlyButton(createTiddlyElement(popup,"li"),this.captionUnSync,null,config.commands.syncing.onChooseServer);
		btn.setAttribute("tiddler",title);
		btn.setAttribute("server.type","");
	}
	createTiddlyElement(createTiddlyElement(popup,"li",null,"listBreak"),"div");
	createTiddlyElement(popup,"li",null,"popupMessage",config.commands.syncing.chooseServer);
	var feeds = store.getTaggedTiddlers("systemServer","title");
	for(var t=0; t<feeds.length; t++) {
		var f = feeds[t];
		var feedServerType = store.getTiddlerSlice(f.title,"Type");
		if(!feedServerType)
			feedServerType = "file";
		var feedServerHost = store.getTiddlerSlice(f.title,"URL");
		if(!feedServerHost)
			feedServerHost = "";
		var feedServerWorkspace = store.getTiddlerSlice(f.title,"Workspace");
		if(!feedServerWorkspace)
			feedServerWorkspace = "";
		var caption = f.title;
		if(serverType == feedServerType && serverHost == feedServerHost && serverWorkspace == feedServerWorkspace) {
			caption = config.commands.syncing.currServerMarker + caption;
		} else {
			caption = config.commands.syncing.notCurrServerMarker + caption;
		}
		btn = createTiddlyButton(createTiddlyElement(popup,"li"),caption,null,config.commands.syncing.onChooseServer);
		btn.setAttribute("tiddler",title);
		btn.setAttribute("server.type",feedServerType);
		btn.setAttribute("server.host",feedServerHost);
		btn.setAttribute("server.workspace",feedServerWorkspace);
	}
};

config.commands.syncing.onChooseServer = function(e)
{
	var tiddler = this.getAttribute("tiddler");
	var serverType = this.getAttribute("server.type");
	if(serverType) {
		store.addTiddlerFields(tiddler,{
			'server.type': serverType,
			'server.host': this.getAttribute("server.host"),
			'server.workspace': this.getAttribute("server.workspace")
			});
	} else {
		store.setValue(tiddler,'server',null);
	}
	return false;
};

config.commands.fields.handlePopup = function(popup,title)
{
	var tiddler = store.fetchTiddler(title);
	if(!tiddler)
		return;
	var fields = {};
	store.forEachField(tiddler,function(tiddler,fieldName,value) {fields[fieldName] = value;},true);
	var items = [];
	for(var t in fields) {
		items.push({field: t,value: fields[t]});
	}
	items.sort(function(a,b) {return a.field < b.field ? -1 : (a.field == b.field ? 0 : +1);});
	if(items.length > 0)
		ListView.create(popup,items,this.listViewTemplate);
	else
		createTiddlyElement(popup,"div",null,null,this.emptyText);
};


// ---------------------------------------------------------------------------------
// Ajax object
// ---------------------------------------------------------------------------------
function Ajax() 
{
	DWREngine.setErrorHandler(function(msg){alert("--"+msg);});
}

Ajax.prototype.loadTiddler = function(title) {
	//debug('ler tiddler com titulo ' + title);
	
	//disparar a chamada para o servidor
	//TODO resolver o namespace
	
	tiddlerService.loadTiddler(this.tiddlerLoaded, "${namespace}", title);
	
}

Ajax.prototype.tiddlerLoaded = function(tiddler){
	//debug("tiddlerLoaded" + tiddler);	

	var text = tiddler.encodedText.htmlDecode();
	if (text.indexOf("<pre>") == 0) {
		text = text.substring(5,text.length-"</pre>".length);
	} else {
		text = Tiddler.unescapeLineBreaks(tiddler.encodedText.htmlDecode());
	}
	
	// atualiza o modelo
	store.saveTiddler(tiddler.title, tiddler.title, text, tiddler.modifier, Date.convertFromYYYYMMDDHHMM(tiddler.modifiedString), tiddler.tagsString, true)
	store.fetchTiddler(tiddler.title).needsLoading=false;
	
	story.refreshTiddler(tiddler.title,null,true);
	
}

Ajax.prototype.saveTiddlers = function(tiddlers) {
	
	// TODO tratar o erro como exce��o. precisa saber quais tiddlers n�o foram salvos para n�o remover da lista de alterados.
	
	// converts the map of changedTiddlers to array
	var array = [];
	var map = store.getChangedTiddlers()
	for (var i in map) {
		var tiddler = map[i];
		// converts array of tags in string of tags (separated by ,)
		tiddler.tagsString = tiddler.getTags().htmlEncode();
		
		tiddler.modifiedString = tiddler.modified.convertToYYYYMMDDHHMM();
		tiddler.createdString = tiddler.created.convertToYYYYMMDDHHMM();
		
		var usePre = config.options.chkUsePreForStorage;
		if (usePre) {
			// o texto precisa ser preparado antes de salvar
			tiddler.encodedText = "<pre>" + tiddler.text.htmlEncode() + "</pre>";
		} else {
			tiddler.encodedText = tiddler.escapeLineBreaks().htmlEncode();
		}
			
		
		array[array.length] = tiddler;
	}
	
	// call server
	tiddlerService.saveUpdateDeleteTiddlers(this.tiddlersSaved, "${namespace}", array, store.getDeletedTiddlers(), null);
	
	clearMessage();
	displayMessage("saving on server...")
		
}

Ajax.prototype.tiddlersSaved = function() {
	clearMessage();
	displayMessage("saved on server");
	store.setDirty(false);
	store.clearChangedDeletedTiddlers();

}

// singleton
var ajax = new Ajax();



//--
//-- Tiddler() object
//--

function Tiddler(title)
{
	
	// namespace is unique for the http session
	this.namespace = "${namespace}";
	
	this.title = title;
	this.text = null;
	this.modifier = null;
	this.modified = new Date();
	this.created = new Date();
	this.links = [];
	this.linksUpdated = false;
	this.tags = [];
	this.fields = {};
	return this;
}

Tiddler.prototype.getLinks = function()
{
	if(this.linksUpdated==false)
		this.changed();
	return this.links;
};

// Returns the fields that are inherited in string field:"value" field2:"value2" format
Tiddler.prototype.getInheritedFields = function()
{
	var f = {};
	for(i in this.fields) {
		if(i=="server.host" || i=="server.workspace" || i=="wikiformat"|| i=="server.type") {
			f[i] = this.fields[i];
		}
	}
	return String.encodeHashMap(f);
};

// Increment the changeCount of a tiddler
Tiddler.prototype.incChangeCount = function()
{
	var c = this.fields['changecount'];
	c = c ? parseInt(c) : 0;
	this.fields['changecount'] = String(c+1);
};

// Clear the changeCount of a tiddler
Tiddler.prototype.clearChangeCount = function()
{
	if(this.fields['changecount']) {
		delete this.fields['changecount'];
	}
};

// Returns true if the tiddler has been updated since the tiddler was created or downloaded
Tiddler.prototype.isTouched = function()
{
	var changeCount = this.fields['changecount'];
	if(changeCount === undefined)
		changeCount = 0;
	return changeCount > 0;
};

// Return the tiddler as an RSS item
Tiddler.prototype.toRssItem = function(uri)
{
	var s = [];
	s.push("<title" + ">" + this.title.htmlEncode() + "</title" + ">");
	s.push("<description>" + wikifyStatic(this.text,null,this).htmlEncode() + "</description>");
	for(var t=0; t<this.tags.length; t++)
		s.push("<category>" + this.tags[t] + "</category>");
	s.push("<link>" + uri + "#" + encodeURIComponent(String.encodeTiddlyLink(this.title)) + "</link>");
	s.push("<pubDate>" + this.modified.toGMTString() + "</pubDate>");
	return s.join("\n");
};

// Format the text for storage in an RSS item
Tiddler.prototype.saveToRss = function(uri)
{
	return "<item>\n" + this.toRssItem(uri) + "\n</item>";
};

// Change the text and other attributes of a tiddler
Tiddler.prototype.set = function(title,text,modifier,modified,tags,created,fields,needsLoading)
{
	this.assign(title,text,modifier,modified,tags,created,fields,needsLoading);
	this.changed();
	return this;
};

// Change the text and other attributes of a tiddler without triggered a tiddler.changed() call
Tiddler.prototype.assign = function(title,text,modifier,modified,tags,created,fields,needsLoading)
{
	if(title != undefined)
		this.title = title;
	if(text != undefined)
		this.text = text;
	if(modifier != undefined)
		this.modifier = modifier;
	if(modified != undefined)
		this.modified = modified;
	if(created != undefined)
		this.created = created;
	if(fields != undefined)
		this.fields = fields;
	if(tags != undefined)
		this.tags = (typeof tags == "string") ? tags.readBracketedList() : tags;
	else if(this.tags == undefined)
		this.tags = [];
		
	if(needsLoading != undefined)
			this.needsLoading = needsLoading;
		
	return this;
};

// Get the tags for a tiddler as a string (space delimited, using [[brackets]] for tags containing spaces)
Tiddler.prototype.getTags = function()
{
	return String.encodeTiddlyLinkList(this.tags);
};

// Test if a tiddler carries a tag
Tiddler.prototype.isTagged = function(tag)
{
	return this.tags.indexOf(tag) != -1;
};

// Static method to convert "\n" to newlines, "\s" to "\"
Tiddler.unescapeLineBreaks = function(text)
{
	return text ? text.unescapeLineBreaks() : "";
};

// Convert newlines to "\n", "\" to "\s"
Tiddler.prototype.escapeLineBreaks = function()
{
	return this.text.escapeLineBreaks();
};

// Updates the secondary information (like links[] array) after a change to a tiddler
Tiddler.prototype.changed = function()
{
	this.links = [];
	var t = this.autoLinkWikiWords() ? 0 : 1;
	var tiddlerLinkRegExp = t==0 ? config.textPrimitives.tiddlerAnyLinkRegExp : config.textPrimitives.tiddlerForcedLinkRegExp;
	tiddlerLinkRegExp.lastIndex = 0;
	var formatMatch = tiddlerLinkRegExp.exec(this.text);
	while(formatMatch) {
		var lastIndex = tiddlerLinkRegExp.lastIndex;
		if(t==0 && formatMatch[1] && formatMatch[1] != this.title) {
			// wikiWordLink
			if(formatMatch.index > 0) {
				var preRegExp = new RegExp(config.textPrimitives.unWikiLink+"|"+config.textPrimitives.anyLetter,"mg");
				preRegExp.lastIndex = formatMatch.index-1;
				var preMatch = preRegExp.exec(this.text);
				if(preMatch.index != formatMatch.index-1)
					this.links.pushUnique(formatMatch[1]);
			} else {
				this.links.pushUnique(formatMatch[1]);
			}
		}
		else if(formatMatch[2-t] && !config.formatterHelpers.isExternalLink(formatMatch[3-t])) // titledBrackettedLink
			this.links.pushUnique(formatMatch[3-t]);
		else if(formatMatch[4-t] && formatMatch[4-t] != this.title) // brackettedLink
			this.links.pushUnique(formatMatch[4-t]);
		tiddlerLinkRegExp.lastIndex = lastIndex;
		formatMatch = tiddlerLinkRegExp.exec(this.text);
	}
	this.linksUpdated = true;
};

Tiddler.prototype.getSubtitle = function()
{
	var modifier = this.modifier;
	if(!modifier)
		modifier = config.messages.subtitleUnknown;
	var modified = this.modified;
	if(modified)
		modified = modified.toLocaleString();
	else
		modified = config.messages.subtitleUnknown;
	return config.messages.tiddlerLinkTooltip.format([this.title,modifier,modified]);
};

Tiddler.prototype.isReadOnly = function()
{
	return readOnly;
};

Tiddler.prototype.autoLinkWikiWords = function()
{
	return !(this.isTagged("systemConfig") || this.isTagged("excludeMissing"));
};

Tiddler.prototype.generateFingerprint = function()
{
	return "0x" + Crypto.hexSha1Str(this.text);
};

Tiddler.prototype.getServerType = function()
{
	var serverType = null;
	if(this.fields && this.fields['server.type'])
		serverType = this.fields['server.type'];
	if(!serverType)
		serverType = this.fields['wikiformat'];
	if(serverType && !config.adaptors[serverType])
		serverType = null;
	return serverType;
};

Tiddler.prototype.getAdaptor = function()
{
	var serverType = this.getServerType();
	return serverType ? new config.adaptors[serverType] : null;
};

//--
//-- TiddlyWiki() object contains Tiddler()s
//--

function TiddlyWiki()
{
	var tiddlers = {}; // Hashmap by name of tiddlers
	
	// for saving on the server
	var changedTiddlers = {}; // Hashmap by name of changed and added tiddlers
	var deletedTiddlers = []; // array of deleted tiddlers' titles
	
	this.tiddlersUpdated = false;
	this.namedNotifications = []; // Array of {name:,notify:} of notification functions
	this.notificationLevel = 0;
	this.slices = {}; // map tiddlerName->(map sliceName->sliceValue). Lazy.
	this.clear = function() {
		tiddlers = {};
		this.setDirty(false);
	};
	this.fetchTiddler = function(title) {
		var t = tiddlers[title];
		return t instanceof Tiddler ? t : null;
	};
	this.deleteTiddler = function(title) {
		delete this.slices[title];
		delete tiddlers[title];
	};
	this.addTiddler = function(tiddler) {
		delete this.slices[tiddler.title];
		tiddlers[tiddler.title] = tiddler;
	};
	this.forEachTiddler = function(callback) {
		for(var t in tiddlers) {
			var tiddler = tiddlers[t];
			if(tiddler instanceof Tiddler)
				callback.call(this,t,tiddler);
		}
	};
	
	this.markAsChanged = function(tiddler) {
		changedTiddlers[tiddler.title] = tiddler;
	}
	this.markAsDeleted = function(title) {
		deletedTiddlers[deletedTiddlers.length] = title;
		if (changedTiddlers[title]) {
			// remove from the changed list
			delete changedTiddlers[title];
		}
	}
	this.getChangedTiddlers = function() {
		return changedTiddlers;
	}
	this.getDeletedTiddlers = function() {
		return deletedTiddlers;
	}
	this.clearChangedDeletedTiddlers = function() {
		changedTiddlers = {};
		deletedTiddlers = [];
	}

}

TiddlyWiki.prototype.setDirty = function(dirty)
{
	this.dirty = dirty;
};

TiddlyWiki.prototype.isDirty = function()
{
	return this.dirty;
};

TiddlyWiki.prototype.suspendNotifications = function()
{
	this.notificationLevel--;
};

TiddlyWiki.prototype.resumeNotifications = function()
{
	this.notificationLevel++;
};

// Invoke the notification handlers for a particular tiddler
TiddlyWiki.prototype.notify = function(title,doBlanket)
{
	if(!this.notificationLevel) {
		for(var t=0; t<this.namedNotifications.length; t++) {
			var n = this.namedNotifications[t];
			if((n.name == null && doBlanket) || (n.name == title))
				n.notify(title);
		}
	}
};

// Invoke the notification handlers for all tiddlers
TiddlyWiki.prototype.notifyAll = function()
{
	if(!this.notificationLevel) {
		for(var t=0; t<this.namedNotifications.length; t++) {
			var n = this.namedNotifications[t];
			if(n.name)
				n.notify(n.name);
		}
	}
};

// Add a notification handler to a tiddler
TiddlyWiki.prototype.addNotification = function(title,fn)
{
	for(var i=0; i<this.namedNotifications.length; i++) {
		if((this.namedNotifications[i].name == title) && (this.namedNotifications[i].notify == fn))
			return this;
	}
	this.namedNotifications.push({name: title, notify: fn});
	return this;
};

TiddlyWiki.prototype.removeTiddler = function(title)
{
	var tiddler = this.fetchTiddler(title);
	if(tiddler) {
		this.markAsDeleted(title);
		this.deleteTiddler(title);
		this.notify(title,true);
		this.setDirty(true);
	}
};

TiddlyWiki.prototype.tiddlerExists = function(title)
{
	var t = this.fetchTiddler(title);
	return t != undefined;
};

TiddlyWiki.prototype.isShadowTiddler = function(title)
{
	return typeof config.shadowTiddlers[title] == "string";
};

TiddlyWiki.prototype.getTiddler = function(title)
{
	var t = this.fetchTiddler(title);
	if(t != undefined) 
	{
		//debug(title + ":needsLoading:" + t.needsLoading);
		// Se o texto ainda não tiver sido carregado, 
		if (t.needsLoading) {
			if (!t.text) {
				t.text = "Lendo..."; //TODO colcoar um gif animado aqui
			}
			ajax.loadTiddler(title);
		}
		return t;
		
	} else {
		// novo tiddler
		return null;
	}
};

TiddlyWiki.prototype.getTiddlerText = function(title,defaultText)
{
  	if(!title)
		return defaultText;
	var pos = title.indexOf(config.textPrimitives.sectionSeparator);
	var section = null;
	if(pos != -1) {
		section = title.substr(pos + config.textPrimitives.sectionSeparator.length);
		title = title.substr(0,pos);
	}
	pos = title.indexOf(config.textPrimitives.sliceSeparator);
	if(pos != -1) {
		var slice = this.getTiddlerSlice(title.substr(0,pos),title.substr(pos + config.textPrimitives.sliceSeparator.length));
		if(slice)
			return slice;
	}
	
	//var tiddler = this.fetchTiddler(title);
	var tiddler = this.getTiddler(title); // centralizei pois esse método chama o ajax, se necessário
	
	if(tiddler) {
		if(!section)
			return tiddler.text;
		var re = new RegExp("(^!{1,6}" + section.escapeRegExp() + ")","mg");
		re.lastIndex = 0;
		var match =  re.exec(tiddler.text);
		if(match) {
			var t = tiddler.text.substr(match.index+match[1].length);
			var re2 = /^!/mg;
			re2.lastIndex = 0;
			match = re2.exec(t); //# search for the next heading
			if(match)
				t = t.substr(0,match.index);
			return t;
		}
		return defaultText;
	}
	if(this.isShadowTiddler(title))
		return config.shadowTiddlers[title];
	if(defaultText != undefined)
		return defaultText;
	return null;
};

TiddlyWiki.prototype.slicesRE = /(?:[\'\/]*~?([\.\w]+)[\'\/]*\:[\'\/]*\s*(.*?)\s*$)|(?:\|[\'\/]*~?([\.\w]+)\:?[\'\/]*\|\s*(.*?)\s*\|)/gm;

// @internal
TiddlyWiki.prototype.calcAllSlices = function(title)
{
	var slices = {};
	var text = this.getTiddlerText(title,"");
	this.slicesRE.lastIndex = 0;
	do {
		var m = this.slicesRE.exec(text);
		if(m) {
			if(m[1])
				slices[m[1]] = m[2];
			else
				slices[m[3]] = m[4];
		}
	} while(m);
	return slices;
};

// Returns the slice of text of the given name
TiddlyWiki.prototype.getTiddlerSlice = function(title,sliceName)
{
	var slices = this.slices[title];
	if(!slices) {
		slices = this.calcAllSlices(title);
		this.slices[title] = slices;
	}
	return slices[sliceName];
};

// Build an hashmap of the specified named slices of a tiddler
TiddlyWiki.prototype.getTiddlerSlices = function(title,sliceNames)
{
	var r = {};
	for(var t=0; t<sliceNames.length; t++) {
		var slice = this.getTiddlerSlice(title,sliceNames[t]);
		if(slice)
			r[sliceNames[t]] = slice;
	}
	return r;
};

TiddlyWiki.prototype.getRecursiveTiddlerText = function(title,defaultText,depth)
{
	var bracketRegExp = new RegExp("(?:\\[\\[([^\\]]+)\\]\\])","mg");
	var text = this.getTiddlerText(title,null);
	if(text == null)
		return defaultText;
	var textOut = [];
	var lastPos = 0;
	do {
		var match = bracketRegExp.exec(text);
		if(match) {
			textOut.push(text.substr(lastPos,match.index-lastPos));
			if(match[1]) {
				if(depth <= 0)
					textOut.push(match[1]);
				else
					textOut.push(this.getRecursiveTiddlerText(match[1],"[[" + match[1] + "]]",depth-1));
			}
			lastPos = match.index + match[0].length;
		} else {
			textOut.push(text.substr(lastPos));
		}
	} while(match);
	return textOut.join("");
};

TiddlyWiki.prototype.setTiddlerTag = function(title,status,tag)
{
	var tiddler = this.fetchTiddler(title);
	if(tiddler) {
		var t = tiddler.tags.indexOf(tag);
		if(t != -1)
			tiddler.tags.splice(t,1);
		if(status)
			tiddler.tags.push(tag);
		tiddler.changed();
		this.incChangeCount(title);
		this.notify(title,true);
		this.setDirty(true);
	}
};

TiddlyWiki.prototype.addTiddlerFields = function(title,fields)
{
	var tiddler = this.fetchTiddler(title);
	if(!tiddler)
		return;
	merge(tiddler.fields,fields);
	tiddler.changed();
	this.incChangeCount(title);
	this.notify(title,true);
	this.setDirty(true);
};

TiddlyWiki.prototype.saveTiddler = function(title,newTitle,newBody,modifier,modified,tags,fields,clearChangeCount,created, cleanSave)
{
	var tiddler = this.fetchTiddler(title);
	if(tiddler) {
		created = created ? created : tiddler.created; // Preserve created date
		this.deleteTiddler(title);
		if (newTitle != title) {
			// will be deleted on server too
			this.markAsDeleted(title);
		}
		
	} else {
		created = created ? created : modified;
		tiddler = new Tiddler();
	}
	tiddler.set(newTitle,newBody,modifier,modified,tags,created,fields,false); // false = doesnt needsLoading
	this.addTiddler(tiddler);
	
	this.markAsChanged(tiddler);
	
	if(clearChangeCount)
		tiddler.clearChangeCount();
	else
		tiddler.incChangeCount();
	if(title != newTitle)
		this.notify(title,true);
	this.notify(newTitle,true);
	
	if (!cleanSave) // when tidders get loaded from server, we use this funtcion without setting them dirty...
		this.setDirty(true);
		
	return tiddler;
};

// Reset the sync status of a freshly synced tiddler
TiddlyWiki.prototype.resetTiddler = function(title)
{
	var tiddler = this.fetchTiddler(title);
	if(tiddler) {
		tiddler.clearChangeCount();
		this.notify(title,true);
		this.setDirty(true);
	}
};

TiddlyWiki.prototype.incChangeCount = function(title)
{
	var tiddler = this.fetchTiddler(title);
	if(tiddler)
		tiddler.incChangeCount();
};

TiddlyWiki.prototype.createTiddler = function(title)
{
	var tiddler = this.fetchTiddler(title);
	if(!tiddler) {
		tiddler = new Tiddler();
		tiddler.title = title;
		this.addTiddler(tiddler);
		this.setDirty(true);
	}
	return tiddler;
};

// Load contents of a TiddlyWiki from an HTML DIV
TiddlyWiki.prototype.loadFromDiv = function(src,idPrefix,noUpdate)
{
	this.idPrefix = idPrefix;
	var storeElem = (typeof src == "string") ? document.getElementById(src) : src;
	if(!storeElem)
		return;
	var tiddlers = this.getLoader().loadTiddlers(this,storeElem.childNodes);
	this.setDirty(false);
	if(!noUpdate) {
		for(var i = 0;i<tiddlers.length; i++)
			tiddlers[i].changed();
	}
};

// Load contents of a TiddlyWiki from a string
// Returns null if there's an error
TiddlyWiki.prototype.importTiddlyWiki = function(text)
{
	var posDiv = locateStoreArea(text);
	if(!posDiv)
		return null;
	var content = "<" + "html><" + "body>" + text.substring(posDiv[0],posDiv[1] + endSaveArea.length) + "<" + "/body><" + "/html>";
	// Create the iframe
	var iframe = document.createElement("iframe");
	iframe.style.display = "none";
	document.body.appendChild(iframe);
	var doc = iframe.document;
	if(iframe.contentDocument)
		doc = iframe.contentDocument; // For NS6
	else if(iframe.contentWindow)
		doc = iframe.contentWindow.document; // For IE5.5 and IE6
	// Put the content in the iframe
	doc.open();
	doc.writeln(content);
	doc.close();
	// Load the content into a TiddlyWiki() object
	var storeArea = doc.getElementById("storeArea");
	this.loadFromDiv(storeArea,"store");
	// Get rid of the iframe
	iframe.parentNode.removeChild(iframe);
	return this;
};

TiddlyWiki.prototype.updateTiddlers = function()
{
	this.tiddlersUpdated = true;
	this.forEachTiddler(function(title,tiddler) {
		tiddler.changed();
	});
};

// Return all tiddlers formatted as an HTML string
TiddlyWiki.prototype.allTiddlersAsHtml = function()
{
	return store.getSaver().externalize(store);
};

// Return an array of tiddlers matching a search regular expression
TiddlyWiki.prototype.search = function(searchRegExp,sortField,excludeTag,match)
{
	var candidates = this.reverseLookup("tags",excludeTag,!!match);
	var results = [];
	for(var t=0; t<candidates.length; t++) {
		if((candidates[t].title.search(searchRegExp) != -1) || (candidates[t].text.search(searchRegExp) != -1))
			results.push(candidates[t]);
	}
	if(!sortField)
		sortField = "title";
	results.sort(function(a,b) {return a[sortField] < b[sortField] ? -1 : (a[sortField] == b[sortField] ? 0 : +1);});
	return results;
};

// Returns a list of all tags in use
//   excludeTag - if present, excludes tags that are themselves tagged with excludeTag
// Returns an array of arrays where [tag][0] is the name of the tag and [tag][1] is the number of occurances
TiddlyWiki.prototype.getTags = function(excludeTag)
{
	var results = [];
	this.forEachTiddler(function(title,tiddler) {
		for(var g=0; g<tiddler.tags.length; g++) {
			var tag = tiddler.tags[g];
			var n = true;
			for(var c=0; c<results.length; c++) {
				if(results[c][0] == tag) {
					n = false;
					results[c][1]++;
				}
			}
			if(n && excludeTag) {
				var t = store.fetchTiddler(tag);
				if(t && t.isTagged(excludeTag))
					n = false;
			}
			if(n)
				results.push([tag,1]);
		}
	});
	results.sort(function(a,b) {return a[0].toLowerCase() < b[0].toLowerCase() ? -1 : (a[0].toLowerCase() == b[0].toLowerCase() ? 0 : +1);});
	return results;
};

// Return an array of the tiddlers that are tagged with a given tag
TiddlyWiki.prototype.getTaggedTiddlers = function(tag,sortField)
{
	return this.reverseLookup("tags",tag,true,sortField);
};

// Return an array of the tiddlers that link to a given tiddler
TiddlyWiki.prototype.getReferringTiddlers = function(title,unusedParameter,sortField)
{
	if(!this.tiddlersUpdated)
		this.updateTiddlers();
	return this.reverseLookup("links",title,true,sortField);
};

// Return an array of the tiddlers that do or do not have a specified entry in the specified storage array (ie, "links" or "tags")
// lookupMatch == true to match tiddlers, false to exclude tiddlers
TiddlyWiki.prototype.reverseLookup = function(lookupField,lookupValue,lookupMatch,sortField)
{
	var results = [];
	this.forEachTiddler(function(title,tiddler) {
		var f = !lookupMatch;
		for(var lookup=0; lookup<tiddler[lookupField].length; lookup++) {
			if(tiddler[lookupField][lookup] == lookupValue)
				f = lookupMatch;
		}
		if(f)
			results.push(tiddler);
	});
	if(!sortField)
		sortField = "title";
	results.sort(function(a,b) {return a[sortField] < b[sortField] ? -1 : (a[sortField] == b[sortField] ? 0 : +1);});
	return results;
};

// Return the tiddlers as a sorted array
TiddlyWiki.prototype.getTiddlers = function(field,excludeTag)
{
	var results = [];
	this.forEachTiddler(function(title,tiddler) {
		if(excludeTag == undefined || !tiddler.isTagged(excludeTag))
			results.push(tiddler);
	});
	if(field)
		results.sort(function(a,b) {return a[field] < b[field] ? -1 : (a[field] == b[field] ? 0 : +1);});
	return results;
};

// Return array of names of tiddlers that are referred to but not defined
TiddlyWiki.prototype.getMissingLinks = function(sortField)
{
	if(!this.tiddlersUpdated)
		this.updateTiddlers();
	var results = [];
	this.forEachTiddler(function (title,tiddler) {
		if(tiddler.isTagged("excludeMissing") || tiddler.isTagged("systemConfig"))
			return;
		for(var n=0; n<tiddler.links.length;n++) {
			var link = tiddler.links[n];
			if(this.fetchTiddler(link) == null && !this.isShadowTiddler(link))
				results.pushUnique(link);
		}
	});
	results.sort();
	return results;
};

// Return an array of names of tiddlers that are defined but not referred to
TiddlyWiki.prototype.getOrphans = function()
{
	var results = [];
	this.forEachTiddler(function (title,tiddler) {
		if(this.getReferringTiddlers(title).length == 0 && !tiddler.isTagged("excludeLists"))
			results.push(title);
	});
	results.sort();
	return results;
};

// Return an array of names of all the shadow tiddlers
TiddlyWiki.prototype.getShadowed = function()
{
	var results = [];
	for(var t in config.shadowTiddlers) {
		if(typeof config.shadowTiddlers[t] == "string")
			results.push(t);
	}
	results.sort();
	return results;
};

// Return an array of tiddlers that have been touched since they were downloaded or created
TiddlyWiki.prototype.getTouched = function()
{
	var results = [];
	this.forEachTiddler(function(title,tiddler) {
		if(tiddler.isTouched())
			results.push(tiddler);
		});
	results.sort();
	return results;
};

// Resolves a Tiddler reference or tiddler title into a Tiddler object, or null if it doesn't exist
TiddlyWiki.prototype.resolveTiddler = function(tiddler)
{
	var t = (typeof tiddler == 'string') ? this.getTiddler(tiddler) : tiddler;
	return t instanceof Tiddler ? t : null;
};

TiddlyWiki.prototype.getLoader = function()
{
	if(!this.loader)
		this.loader = new TW21Loader();
	return this.loader;
};

TiddlyWiki.prototype.getSaver = function()
{
	if(!this.saver)
		this.saver = new TW21Saver();
	return this.saver;
};

// Filter a list of tiddlers
TiddlyWiki.prototype.filterTiddlers = function(filter)
{
	var results = [];
	if(filter) {
		var tiddler;
		var re = /([^ \[\]]+)|(?:\[([ \w]+)\[([^\]]+)\]\])|(?:\[\[([^\]]+)\]\])/mg;
		var match = re.exec(filter);
		while(match) {
			if(match[1] || match[4]) {
				var title = match[1] ? match[1] : match[4];
				tiddler = this.fetchTiddler(title);
				if(tiddler) {
					results.pushUnique(tiddler);
				} else if(store.isShadowTiddler(title)) {
					tiddler = new Tiddler();
					tiddler.set(title,store.getTiddlerText(title));
					results.pushUnique(tiddler);
				}
			} else if(match[2]) {
				switch(match[2]) {
					case "tag":
						this.forEachTiddler(function(title,tiddler) {
							if(tiddler.isTagged(match[3]))
								results.pushUnique(tiddler);
						});
						break;
					case "sort":
						results = this.sortTiddlers(results,match[3]);
						break; 
				}
			}
			match = re.exec(filter);
		}
	}
	return results;
};

// Sort a list of tiddlers
TiddlyWiki.prototype.sortTiddlers = function(tiddlers,field)
{
	var asc = +1;
	switch(field.substr(0,1)) {
		case "-":
			asc = -1;
			// Note: this fall-through is intentional
		case "+":
			field = field.substr(1);
			break;
	}
	if(TiddlyWiki.standardFieldAccess[field])
		tiddlers.sort(function(a,b) {return a[field] < b[field] ? -asc : (a[field] == b[field] ? 0 : asc);});
	else
		tiddlers.sort(function(a,b) {return a.fields[field] < b.fields[field] ? -asc : (a.fields[field] == b.fields[field] ? 0 : +asc);});
	return tiddlers;
};
// Returns true if path is a valid field name (path),
// i.e. a sequence of identifiers, separated by '.'
TiddlyWiki.isValidFieldName = function(name)
{
	var match = /[a-zA-Z_]\w*(\.[a-zA-Z_]\w*)*/.exec(name);
	return match && (match[0] == name);
};

// Throws an exception when name is not a valid field name.
TiddlyWiki.checkFieldName = function(name)
{
	if(!TiddlyWiki.isValidFieldName(name))
		throw config.messages.invalidFieldName.format([name]);
};

function StringFieldAccess(n,readOnly)
{
	this.set = readOnly ?
			function(t,v) {if(v != t[n]) throw config.messages.fieldCannotBeChanged.format([n]);} :
			function(t,v) {if(v != t[n]) {t[n] = v; return true;}};
	this.get = function(t) {return t[n];};
}

function DateFieldAccess(n)
{
	this.set = function(t,v) {
		var d = v instanceof Date ? v : Date.convertFromYYYYMMDDHHMM(v);
		if(d != t[n]) {
			t[n] = d; return true;
		}
	};
	this.get = function(t) {return t[n].convertToYYYYMMDDHHMM();};
}

function LinksFieldAccess(n)
{
	this.set = function(t,v) {
		var s = (typeof v == "string") ? v.readBracketedList() : v;
		if(s.toString() != t[n].toString()) {
			t[n] = s; return true;
		}
	};
	this.get = function(t) {return String.encodeTiddlyLinkList(t[n]);};
}

TiddlyWiki.standardFieldAccess = {
	// The set functions return true when setting the data has changed the value.
	"title":    new StringFieldAccess("title",true),
	// Handle the "tiddler" field name as the title
	"tiddler":  new StringFieldAccess("title",true),
	"text":     new StringFieldAccess("text"),
	"modifier": new StringFieldAccess("modifier"),
	"modified": new DateFieldAccess("modified"),
	"created":  new DateFieldAccess("created"),
	"tags":     new LinksFieldAccess("tags")
};

TiddlyWiki.isStandardField = function(name)
{
	return TiddlyWiki.standardFieldAccess[name] != undefined;
};

// Sets the value of the given field of the tiddler to the value.
// Setting an ExtendedField's value to null or undefined removes the field.
// Setting a namespace to undefined removes all fields of that namespace.
// The fieldName is case-insensitive.
// All values will be converted to a string value.
TiddlyWiki.prototype.setValue = function(tiddler,fieldName,value)
{
	TiddlyWiki.checkFieldName(fieldName);
	var t = this.resolveTiddler(tiddler);
	if(!t)
		return;
	fieldName = fieldName.toLowerCase();
	var isRemove = (value === undefined) || (value === null);
	var accessor = TiddlyWiki.standardFieldAccess[fieldName];
	if(accessor) {
		if(isRemove)
			// don't remove StandardFields
			return;
		var h = TiddlyWiki.standardFieldAccess[fieldName];
		if(!h.set(t,value))
			return;
	} else {
		var oldValue = t.fields[fieldName];
		if(isRemove) {
			if(oldValue !== undefined) {
				// deletes a single field
				delete t.fields[fieldName];
			} else {
				// no concrete value is defined for the fieldName
				// so we guess this is a namespace path.
				// delete all fields in a namespace
				var re = new RegExp('^'+fieldName+'\\.');
				var dirty = false;
				for(var n in t.fields) {
					if(n.match(re)) {
						delete t.fields[n];
						dirty = true;
					}
				}
				if(!dirty)
					return;
			}
		} else {
			// the "normal" set case. value is defined (not null/undefined)
			// For convenience provide a nicer conversion Date->String
			value = value instanceof Date ? value.convertToYYYYMMDDHHMMSSMMM() : String(value);
			if(oldValue == value)
				return;
			t.fields[fieldName] = value;
		}
	}
	// When we are here the tiddler/store really was changed.
	this.notify(t.title,true);
	if(!fieldName.match(/^temp\./))
		this.setDirty(true);
};

// Returns the value of the given field of the tiddler.
// The fieldName is case-insensitive.
// Will only return String values (or undefined).
TiddlyWiki.prototype.getValue = function(tiddler,fieldName)
{
	var t = this.resolveTiddler(tiddler);
	if(!t)
		return undefined;
	fieldName = fieldName.toLowerCase();
	var accessor = TiddlyWiki.standardFieldAccess[fieldName];
	if(accessor) {
		return accessor.get(t);
	}
	return t.fields[fieldName];
};

// Calls the callback function for every field in the tiddler.
// When callback function returns a non-false value the iteration stops
// and that value is returned.
// The order of the fields is not defined.
// @param callback a function(tiddler,fieldName,value).
TiddlyWiki.prototype.forEachField = function(tiddler,callback,onlyExtendedFields)
{
	var t = this.resolveTiddler(tiddler);
	if(!t)
		return undefined;
	var n,result;
	for(n in t.fields) {
		result = callback(t,n,t.fields[n]);
		if(result)
			return result;
		}
	if(onlyExtendedFields)
		return undefined;
	for(n in TiddlyWiki.standardFieldAccess) {
		if(n == "tiddler")
			// even though the "title" field can also be referenced through the name "tiddler"
			// we only visit this field once.
			continue;
		result = callback(t,n,TiddlyWiki.standardFieldAccess[n].get(t));
		if(result)
			return result;
	}
	return undefined;
};

//--
//-- Story functions
//--

function Story(container,idPrefix)
{
	this.container = container;
	this.idPrefix = idPrefix;
	this.highlightRegExp = null;
}

Story.prototype.forEachTiddler = function(fn)
{
	var place = document.getElementById(this.container);
	if(!place)
		return;
	var e = place.firstChild;
	while(e) {
		var n = e.nextSibling;
		var title = e.getAttribute("tiddler");
		fn.call(this,title,e);
		e = n;
	}
};

Story.prototype.displayTiddlers = function(srcElement,titles,template,animate,unused,customFields,toggle)
{
	for(var t = titles.length-1;t>=0;t--)
		this.displayTiddler(srcElement,titles[t],template,animate,unused,customFields);
};

Story.prototype.displayTiddler = function(srcElement,tiddler,template,animate,unused,customFields,toggle)
{
	var title = (tiddler instanceof Tiddler)? tiddler.title : tiddler;  
	var place = document.getElementById(this.container);
	var tiddlerElem = document.getElementById(this.idPrefix + title);
	if(tiddlerElem) {
		if(toggle)
			this.closeTiddler(title,true);
		else
			this.refreshTiddler(title,template,false,customFields);
	} else {
		var before = this.positionTiddler(srcElement);
		tiddlerElem = this.createTiddler(place,before,title,template,customFields);
	}
	if(srcElement && typeof srcElement !== "string") {
		if(config.options.chkAnimate && (animate == undefined || animate == true) && anim && typeof Zoomer == "function" && typeof Scroller == "function")
			anim.startAnimating(new Zoomer(title,srcElement,tiddlerElem),new Scroller(tiddlerElem));
		else
			window.scrollTo(0,ensureVisible(tiddlerElem));
	}
};

Story.prototype.positionTiddler = function(srcElement)
{
	var place = document.getElementById(this.container);
	var before = null;
	if(typeof srcElement == "string") {
		switch(srcElement) {
			case "top":
				before = place.firstChild;
				break;
			case "bottom":
				before = null;
				break;
		}
	} else {
		var after = this.findContainingTiddler(srcElement);
		if(after == null) {
			before = place.firstChild;
		} else if(after.nextSibling) {
			before = after.nextSibling;
			if(before.nodeType != 1)
				before = null;
		}
	}
	return before;
};

Story.prototype.createTiddler = function(place,before,title,template,customFields)
{
	var tiddlerElem = createTiddlyElement(null,"div",this.idPrefix + title,"tiddler");
	tiddlerElem.setAttribute("refresh","tiddler");
	if(customFields)
		tiddlerElem.setAttribute("tiddlyFields",customFields);
	place.insertBefore(tiddlerElem,before);
	var defaultText = null;
	if(!store.tiddlerExists(title) && !store.isShadowTiddler(title))
		defaultText = this.loadMissingTiddler(title,customFields,tiddlerElem);
	this.refreshTiddler(title,template,false,customFields,defaultText);
	return tiddlerElem;
};

Story.prototype.loadMissingTiddler = function(title,fields,tiddlerElem)
{
	var tiddler = new Tiddler(title);
	tiddler.fields = typeof fields == "string" ?  fields.decodeHashMap() : (fields ? fields : {});
	var serverType = tiddler.getServerType();
	var host = tiddler.fields['server.host'];
	var workspace = tiddler.fields['server.workspace'];
	if(!serverType || !host)
		return null;
	var sm = new SyncMachine(serverType,{
			start: function() {
				return this.openHost(host,"openWorkspace");
			},
			openWorkspace: function() {
				return this.openWorkspace(workspace,"getTiddler");
			},
			getTiddler: function() {
				return this.getTiddler(title,"onGetTiddler");
			},
			onGetTiddler: function(context) {
				var tiddler = context.tiddler;
				if(tiddler && tiddler.text) {
					var downloaded = new Date();
					if(!tiddler.created)
						tiddler.created = downloaded;
					if(!tiddler.modified)
						tiddler.modified = tiddler.created;
					store.saveTiddler(tiddler.title,tiddler.title,tiddler.text,tiddler.modifier,tiddler.modified,tiddler.tags,tiddler.fields,true,tiddler.created);
					autoSaveChanges();
				}
				delete this;
				return true;
			},
			error: function(message) {
				displayMessage("Error loading missing tiddler from %0: %1".format([host,message]));
			}
		});
	sm.go();
	return config.messages.loadingMissingTiddler.format([title,serverType,host,workspace]);
};

Story.prototype.chooseTemplateForTiddler = function(title,template)
{
	if(!template)
		template = DEFAULT_VIEW_TEMPLATE;
	if(template == DEFAULT_VIEW_TEMPLATE || template == DEFAULT_EDIT_TEMPLATE)
		template = config.tiddlerTemplates[template];
	return template;
};

Story.prototype.getTemplateForTiddler = function(title,template,tiddler)
{
	return store.getRecursiveTiddlerText(template,null,10);
};

Story.prototype.refreshTiddler = function(title,template,force,customFields,defaultText)
{
	var tiddlerElem = document.getElementById(this.idPrefix + title);
	if(tiddlerElem) {
		if(tiddlerElem.getAttribute("dirty") == "true" && !force)
			return tiddlerElem;
		template = this.chooseTemplateForTiddler(title,template);
		var currTemplate = tiddlerElem.getAttribute("template");
		if((template != currTemplate) || force) {
			var tiddler = store.getTiddler(title);
			if(!tiddler) {
				tiddler = new Tiddler();
				if(store.isShadowTiddler(title)) {
					tiddler.set(title,store.getTiddlerText(title),config.views.wikified.shadowModifier,version.date,[],version.date, false); // false = doesnt needsLoading
				} else {
					var text = template=="EditTemplate" ?
								config.views.editor.defaultText.format([title]) :
								config.views.wikified.defaultText.format([title]);
					text = defaultText ? defaultText : text;
					var fields = customFields ? customFields.decodeHashMap() : null;
					tiddler.set(title,text,config.views.wikified.defaultModifier,version.date,[],version.date,fields, false); // false = doesnt needsLoading
				}
			}
			tiddlerElem.setAttribute("tags",tiddler.tags.join(" "));
			tiddlerElem.setAttribute("tiddler",title);
			tiddlerElem.setAttribute("template",template);
			var me = this;
			tiddlerElem.onmouseover = this.onTiddlerMouseOver;
			tiddlerElem.onmouseout = this.onTiddlerMouseOut;
			tiddlerElem.ondblclick = this.onTiddlerDblClick;
			tiddlerElem[window.event?"onkeydown":"onkeypress"] = this.onTiddlerKeyPress;
			var html = this.getTemplateForTiddler(title,template,tiddler);
			tiddlerElem.innerHTML = html;
			applyHtmlMacros(tiddlerElem,tiddler);
			if(store.getTaggedTiddlers(title).length > 0)
				addClass(tiddlerElem,"isTag");
			else
				removeClass(tiddlerElem,"isTag");
			if(!store.tiddlerExists(title)) {
				if(store.isShadowTiddler(title))
					addClass(tiddlerElem,"shadow");
				else
					addClass(tiddlerElem,"missing");
			} else {
				removeClass(tiddlerElem,"shadow");
				removeClass(tiddlerElem,"missing");
			}
			if(customFields)
				this.addCustomFields(tiddlerElem,customFields);
			forceReflow();
		}
	}
	return tiddlerElem;
};

Story.prototype.addCustomFields = function(place,customFields)
{
	var fields = customFields.decodeHashMap();
	var w = document.createElement("div");
	w.style.display = "none";
	place.appendChild(w);
	for(var t in fields) {
		var e = document.createElement("input");
		e.setAttribute("type","text");
		e.setAttribute("value",fields[t]);
		w.appendChild(e);
		e.setAttribute("edit",t);
	}
};

Story.prototype.refreshAllTiddlers = function(force)
{
	var place = document.getElementById(this.container);
	var e = place.firstChild;
	if(!e)
		return;
	this.refreshTiddler(e.getAttribute("tiddler"),force ? null : e.getAttribute("template"),true);
	while((e = e.nextSibling) != null)
		this.refreshTiddler(e.getAttribute("tiddler"),force ? null : e.getAttribute("template"),true);
};

Story.prototype.onTiddlerMouseOver = function(e)
{
	if(window.addClass instanceof Function)
		addClass(this,"selected");
};

Story.prototype.onTiddlerMouseOut = function(e)
{
	if(window.removeClass instanceof Function)
		removeClass(this,"selected");
};

Story.prototype.onTiddlerDblClick = function(ev)
{
	var e = ev ? ev : window.event;
	var theTarget = resolveTarget(e);
	if(theTarget && theTarget.nodeName.toLowerCase() != "input" && theTarget.nodeName.toLowerCase() != "textarea") {
		if(document.selection && document.selection.empty)
			document.selection.empty();
		config.macros.toolbar.invokeCommand(this,"defaultCommand",e);
		e.cancelBubble = true;
		if(e.stopPropagation) e.stopPropagation();
		return true;
	} else {
		return false;
	}
};

Story.prototype.onTiddlerKeyPress = function(ev)
{
	var e = ev ? ev : window.event;
	clearMessage();
	var consume = false;
	var title = this.getAttribute("tiddler");
	var target = resolveTarget(e);
	switch(e.keyCode) {
		case 9: // Tab
			if(config.options.chkInsertTabs && target.tagName.toLowerCase() == "textarea") {
				replaceSelection(target,String.fromCharCode(9));
				consume = true;
			}
			if(config.isOpera) {
				target.onblur = function() {
					this.focus();
					this.onblur = null;
				};
			}
			break;
		case 13: // Ctrl-Enter
		case 10: // Ctrl-Enter on IE PC
		case 77: // Ctrl-Enter is "M" on some platforms
			if(e.ctrlKey) {
				blurElement(this);
				config.macros.toolbar.invokeCommand(this,"defaultCommand",e);
				consume = true;
			}
			break;
		case 27: // Escape
			blurElement(this);
			config.macros.toolbar.invokeCommand(this,"cancelCommand",e);
			consume = true;
			break;
	}
	e.cancelBubble = consume;
	if(consume) {
		if(e.stopPropagation) e.stopPropagation(); // Stop Propagation
		e.returnValue = true; // Cancel The Event in IE
		if(e.preventDefault ) e.preventDefault(); // Cancel The Event in Moz
	}
	return !consume;
};

Story.prototype.getTiddlerField = function(title,field)
{
	var tiddlerElem = document.getElementById(this.idPrefix + title);
	var e = null;
	if(tiddlerElem != null) {
		var children = tiddlerElem.getElementsByTagName("*");
		for(var t=0; t<children.length; t++) {
			var c = children[t];
			if(c.tagName.toLowerCase() == "input" || c.tagName.toLowerCase() == "textarea") {
				if(!e)
					e = c;
				if(c.getAttribute("edit") == field)
					e = c;
			}
		}
	}
	return e;
};

Story.prototype.focusTiddler = function(title,field)
{
	var e = this.getTiddlerField(title,field);
	if(e) {
		e.focus();
		e.select();
	}
};

Story.prototype.blurTiddler = function(title)
{
	var tiddlerElem = document.getElementById(this.idPrefix + title);
	if(tiddlerElem != null && tiddlerElem.focus && tiddlerElem.blur) {
		tiddlerElem.focus();
		tiddlerElem.blur();
	}
};

Story.prototype.setTiddlerField = function(title,tag,mode,field)
{
	var c = story.getTiddlerField(title,field);

	var tags = c.value.readBracketedList();
	tags.setItem(tag,mode);
	c.value = String.encodeTiddlyLinkList(tags);
};

Story.prototype.setTiddlerTag = function(title,tag,mode)
{
	Story.prototype.setTiddlerField(title,tag,mode,"tags");
};

Story.prototype.closeTiddler = function(title,animate,unused)
{
	var tiddlerElem = document.getElementById(this.idPrefix + title);
	if(tiddlerElem != null) {
		clearMessage();
		this.scrubTiddler(tiddlerElem);
		if(config.options.chkAnimate && animate && anim && typeof Slider == "function")
			anim.startAnimating(new Slider(tiddlerElem,false,null,"all"));
		else {
			removeNode(tiddlerElem);
			forceReflow();
		}
	}
};

Story.prototype.scrubTiddler = function(tiddlerElem)
{
	tiddlerElem.id = null;
};

Story.prototype.setDirty = function(title,dirty)
{
	var tiddlerElem = document.getElementById(this.idPrefix + title);
	if(tiddlerElem != null)
		tiddlerElem.setAttribute("dirty",dirty ? "true" : "false");
};

Story.prototype.isDirty = function(title)
{
	var tiddlerElem = document.getElementById(this.idPrefix + title);
	if(tiddlerElem != null)
		return tiddlerElem.getAttribute("dirty") == "true";
	return null;
};

Story.prototype.areAnyDirty = function()
{
	var r = false;
	this.forEachTiddler(function(title,element) {
		if(this.isDirty(title))
			r = true;
	});
	return r;
};

Story.prototype.closeAllTiddlers = function(exclude)
{
	clearMessage();
	this.forEachTiddler(function(title,element) {
		if((title != exclude) && element.getAttribute("dirty") != "true")
			this.closeTiddler(title);
	});
	window.scrollTo(0,ensureVisible(this.container));
};

Story.prototype.isEmpty = function()
{
	var place = document.getElementById(this.container);
	return place && place.firstChild == null;
};

Story.prototype.search = function(text,useCaseSensitive,useRegExp)
{
	this.closeAllTiddlers();
	highlightHack = new RegExp(useRegExp ?	 text : text.escapeRegExp(),useCaseSensitive ? "mg" : "img");
	var matches = store.search(highlightHack,"title","excludeSearch");
	this.displayTiddlers(null,matches);
	highlightHack = null;
	var q = useRegExp ? "/" : "'";
	if(matches.length > 0)
		displayMessage(config.macros.search.successMsg.format([matches.length.toString(),q + text + q]));
	else
		displayMessage(config.macros.search.failureMsg.format([q + text + q]));
};

Story.prototype.findContainingTiddler = function(e)
{
	while(e && !hasClass(e,"tiddler"))
		e = e.parentNode;
	return e;
};

Story.prototype.gatherSaveFields = function(e,fields)
{
	if(e && e.getAttribute) {
		var f = e.getAttribute("edit");
		if(f)
			fields[f] = e.value.replace(/\r/mg,"");
		if(e.hasChildNodes()) {
			var c = e.childNodes;
			for(var t=0; t<c.length; t++)
				this.gatherSaveFields(c[t],fields);
		}
	}
};

Story.prototype.hasChanges = function(title)
{
	var e = document.getElementById(this.idPrefix + title);
	if(e != null) {
		var fields = {};
		this.gatherSaveFields(e,fields);
		var tiddler = store.fetchTiddler(title);
		if(!tiddler)
			return false;
		for(var n in fields) {
			if(store.getValue(title,n) != fields[n])
				return true;
		}
	}
	return false;
};

Story.prototype.saveTiddler = function(title,minorUpdate)
{
	var tiddlerElem = document.getElementById(this.idPrefix + title);
	if(tiddlerElem != null) {
		var fields = {};
		this.gatherSaveFields(tiddlerElem,fields);
		var newTitle = fields.title ? fields.title : title;
		if(!store.tiddlerExists(newTitle))
			newTitle = newTitle.trim();
		if(store.tiddlerExists(newTitle) && newTitle != title) {
			if(!confirm(config.messages.overwriteWarning.format([newTitle.toString()])))
				return null;
		}
		if(newTitle != title)
			this.closeTiddler(newTitle,false);
		tiddlerElem.id = this.idPrefix + newTitle;
		tiddlerElem.setAttribute("tiddler",newTitle);
		tiddlerElem.setAttribute("template",DEFAULT_VIEW_TEMPLATE);
		tiddlerElem.setAttribute("dirty","false");
		if(config.options.chkForceMinorUpdate)
			minorUpdate = !minorUpdate;
		if(!store.tiddlerExists(newTitle))
			minorUpdate = false;
		var newDate = new Date();
		var extendedFields = store.tiddlerExists(newTitle) ? store.fetchTiddler(newTitle).fields : (newTitle!=title && store.tiddlerExists(title) ? store.fetchTiddler(title).fields : {});
		for(var n in fields) {
			if(!TiddlyWiki.isStandardField(n))
				extendedFields[n] = fields[n];
		}
		var tiddler = store.saveTiddler(title,newTitle,fields.text,minorUpdate ? undefined : config.options.txtUserName,minorUpdate ? undefined : newDate,fields.tags,extendedFields);
		autoSaveChanges(null,[tiddler]);
		return newTitle;
	}
	return null;
};

Story.prototype.permaView = function()
{
	var links = [];
	this.forEachTiddler(function(title,element) {
		links.push(String.encodeTiddlyLink(title));
	});
	var t = encodeURIComponent(links.join(" "));
	if(t == "")
		t = "#";
	if(window.location.hash != t)
		window.location.hash = t;
};


Story.prototype.switchTheme = function(theme)
{
	if(safeMode) 
		return;
		
	isAvailable = function(title) { 
		var s = title ? title.indexOf(config.textPrimitives.sectionSeparator) : -1; 
		if(s!=-1) 
			title = title.substr(0,s); 
		return store.tiddlerExists(title) || store.isShadowTiddler(title); 
 	};

	getSlice = function(theme,slice) {
		var r = store.getTiddlerSlice(theme,slice);
		if(r && r.indexOf(config.textPrimitives.sectionSeparator)==0)
			r = theme + r;
		return isAvailable(r) ? r : slice;
	};

	replaceNotification = function(i,name,newName) {
		if(name==newName)
			return name;
		if(store.namedNotifications[i].name == name) {
			store.namedNotifications[i].name = newName;
			return newName;
		}
		return name;
	};

	for(var i=0; i<config.notifyTiddlers.length; i++) {
		var name = config.notifyTiddlers[i].name;
		switch(name) {
		case "PageTemplate":
			config.refreshers.pageTemplate = replaceNotification(i,config.refreshers.pageTemplate,getSlice(theme,name));
			break;
		case "StyleSheet":
			removeStyleSheet(config.refreshers.styleSheet);
			config.refreshers.styleSheet = replaceNotification(i,config.refreshers.styleSheet,getSlice(theme,name));
			break;
		case "ColorPalette":
			config.refreshers.colorPalette = replaceNotification(i,config.refreshers.colorPalette,getSlice(theme,name));
			break;
		default:
			break;
		}
	}
	config.tiddlerTemplates[DEFAULT_VIEW_TEMPLATE] = getSlice(theme,"ViewTemplate");
	config.tiddlerTemplates[DEFAULT_EDIT_TEMPLATE] = getSlice(theme,"EditTemplate");
	if(!startingUp) {
		refreshAll();
		story.refreshAllTiddlers(true);
		config.options.txtTheme = theme;
		saveOptionCookie("txtTheme");
	}
};

<jsp:include page="coral_part2.jsp" />