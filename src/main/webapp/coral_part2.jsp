
//--
//-- Backstage
//--

var backstage = {
	area: null,
	toolbar: null,
	button: null,
	showButton: null,
	hideButton: null,
	cloak: null,
	panel: null,
	panelBody: null,
	panelFooter: null,
	currTabName: null,
	currTabElem: null,
	content: null,

	init: function() {
		var cmb = config.messages.backstage;
		this.area = document.getElementById("backstageArea");
		this.toolbar = document.getElementById("backstageToolbar");
		this.button = document.getElementById("backstageButton");
		this.button.style.display = "block";
		var t = cmb.open.text + " " + glyph("bentArrowLeft");
		this.showButton = createTiddlyButton(this.button,t,cmb.open.tooltip,
						function (e) {backstage.show(); return false;},null,"backstageShow");
		t = glyph("bentArrowRight") + " " + cmb.close.text;
		this.hideButton = createTiddlyButton(this.button,t,cmb.close.tooltip,
						function (e) {backstage.hide(); return false;},null,"backstageHide");
		this.cloak = document.getElementById("backstageCloak");
		this.panel = document.getElementById("backstagePanel");
		this.panelFooter = createTiddlyElement(this.panel,"div",null,"backstagePanelFooter");
		this.panelBody = createTiddlyElement(this.panel,"div",null,"backstagePanelBody");
		this.cloak.onmousedown = function(e) {
			backstage.switchTab(null);
		};
		createTiddlyText(this.toolbar,cmb.prompt);
		for(t=0; t<config.backstageTasks.length; t++) {
			var taskName = config.backstageTasks[t];
			var task = config.tasks[taskName];
			var handler = task.action ? this.onClickCommand : this.onClickTab;
			var text = task.text + (task.action ? "" : glyph("downTriangle"));
			var btn = createTiddlyButton(this.toolbar,text,task.tooltip,handler,"backstageTab");
			btn.setAttribute("task",taskName);
			addClass(btn,task.action ? "backstageAction" : "backstageTask");
			}
		this.content = document.getElementById("contentWrapper");
		if(config.options.chkBackstage)
			this.show();
		else
			this.hide();
	},

	isVisible: function() {
		return this.area ? this.area.style.display == "block" : false;
	},

	show: function() {
		this.area.style.display = "block";
		if(anim && config.options.chkAnimate) {
			backstage.toolbar.style.left = findWindowWidth() + "px";
			var p = [
				{style: "left", start: findWindowWidth(), end: 0, template: "%0px"}
			];
			anim.startAnimating(new Morpher(backstage.toolbar,config.animDuration,p));
		} else {
			backstage.area.style.left = "0px";
		}
		this.showButton.style.display = "none";
		this.hideButton.style.display = "block";
		config.options.chkBackstage = true;
		saveOptionCookie("chkBackstage");
		addClass(this.content,"backstageVisible");
	},

	hide: function() {
		if(this.currTabElem) {
			this.switchTab(null);
		} else {
			backstage.toolbar.style.left = "0px";
			if(anim && config.options.chkAnimate) {
				var p = [
					{style: "left", start: 0, end: findWindowWidth(), template: "%0px"}
				];
				var c = function(element,properties) {backstage.area.style.display = "none";};
				anim.startAnimating(new Morpher(backstage.toolbar,config.animDuration,p,c));
			} else {
				this.area.style.display = "none";
			}
			this.showButton.style.display = "block";
			this.hideButton.style.display = "none";
			config.options.chkBackstage = false;
			saveOptionCookie("chkBackstage");
			removeClass(this.content,"backstageVisible");
		}
	},

	onClickCommand: function(e) {
		var task = config.tasks[this.getAttribute("task")];
		displayMessage(task);
		if(task.action) {
			backstage.switchTab(null);
			task.action();
		}
		return false;
	},

	onClickTab: function(e) {
		backstage.switchTab(this.getAttribute("task"));
		return false;
	},

	// Switch to a given tab, or none if null is passed
	switchTab: function(tabName) {
		var tabElem = null;
		var e = this.toolbar.firstChild;
		while(e)
			{
			if(e.getAttribute && e.getAttribute("task") == tabName)
				tabElem = e;
			e = e.nextSibling;
			}
		if(tabName == backstage.currTabName)
			return;
		if(backstage.currTabElem) {
			removeClass(this.currTabElem,"backstageSelTab");
		}
		if(tabElem && tabName) {
			backstage.preparePanel();
			addClass(tabElem,"backstageSelTab");
			var task = config.tasks[tabName];
			wikify(task.content,backstage.panelBody,null,null);
			backstage.showPanel();
		} else if(backstage.currTabElem) {
			backstage.hidePanel();
		}
		backstage.currTabName = tabName;
		backstage.currTabElem = tabElem;
	},

	isPanelVisible: function() {
		return backstage.panel ? backstage.panel.style.display == "block" : false;
	},

	preparePanel: function() {
		backstage.cloak.style.height = findWindowHeight() + "px";
		backstage.cloak.style.display = "block";
		removeChildren(backstage.panelBody);
		return backstage.panelBody;
	},

	showPanel: function() {
		backstage.panel.style.display = "block";
		if(anim && config.options.chkAnimate) {
			backstage.panel.style.top = (-backstage.panel.offsetHeight) + "px";
			var p = [
				{style: "top", start: -backstage.panel.offsetHeight, end: 0, template: "%0px"}
			];
			anim.startAnimating(new Morpher(backstage.panel,config.animDuration,p),new Scroller(backstage.panel,false));
		} else {
			backstage.panel.style.top = "0px";
		}
		return backstage.panelBody;
	},

	hidePanel: function() {
		backstage.currTabName = null;
		backstage.currTabElem = null;
		if(anim && config.options.chkAnimate) {
			var p = [
				{style: "top", start: 0, end: -(backstage.panel.offsetHeight), template: "%0px"},
				{style: "display", atEnd: "none"}
			];
			var c = function(element,properties) {backstage.cloak.style.display = "none";};
			anim.startAnimating(new Morpher(backstage.panel,config.animDuration,p,c));
		 } else {
			backstage.panel.style.display = "none";
			backstage.cloak.style.display = "none";
		}
	}
};

config.macros.backstage = {};

config.macros.backstage.handler = function(place,macroName,params,wikifier,paramString,tiddler)
{
	var backstageTask = config.tasks[params[0]];
	if(backstageTask)
		createTiddlyButton(place,backstageTask.text,backstageTask.tooltip,function(e) {backstage.switchTab(params[0]); return false;});
};

//--
//-- ImportTiddlers macro
//--

config.macros.importTiddlers.handler = function(place,macroName,params,wikifier,paramString,tiddler)
{
	if(readOnly) {
		createTiddlyElement(place,"div",null,"marked",this.readOnlyWarning);
		return;
	}
	var w = new Wizard();
	w.createWizard(place,this.wizardTitle);
	this.restart(w);
};

config.macros.importTiddlers.onCancel = function(e)
{
	var wizard = new Wizard(this);
	var place = wizard.clear();
	config.macros.importTiddlers.restart(wizard);
	return false;
};

config.macros.importTiddlers.restart = function(wizard)
{
	wizard.addStep(this.step1Title,this.step1Html);
	var s = wizard.getElement("selTypes");
	for(var t in config.adaptors) {
		var e = createTiddlyElement(s,"option",null,null,t);
		e.value = t;
	}
	s = wizard.getElement("selFeeds");
	var feeds = this.getFeeds();
	for(t in feeds) {
		e = createTiddlyElement(s,"option",null,null,t);
		e.value = t;
	}
	wizard.setValue("feeds",feeds);
	s.onchange = config.macros.importTiddlers.onFeedChange;
	var fileInput = wizard.getElement("txtBrowse");
	fileInput.onchange = config.macros.importTiddlers.onBrowseChange;
	fileInput.onkeyup = config.macros.importTiddlers.onBrowseChange;
	wizard.setButtons([{caption: this.openLabel, tooltip: this.openPrompt, onClick: config.macros.importTiddlers.onOpen}]);
};

config.macros.importTiddlers.getFeeds = function()
{
	var feeds = {};
	var tagged = store.getTaggedTiddlers("systemServer","title");
	for(var t=0; t<tagged.length; t++) {
		var title = tagged[t].title;
		var serverType = store.getTiddlerSlice(title,"Type");
		if(!serverType)
			serverType = "file";
		feeds[title] = {title: title,
						url: store.getTiddlerSlice(title,"URL"),
						workspace: store.getTiddlerSlice(title,"Workspace"),
						workspaceList: store.getTiddlerSlice(title,"WorkspaceList"),
						tiddlerFilter: store.getTiddlerSlice(title,"TiddlerFilter"),
						serverType: serverType,
						description: store.getTiddlerSlice(title,"Description")};
	}
	return feeds;
};

config.macros.importTiddlers.onFeedChange = function(e)
{
	var wizard = new Wizard(this);
	var selTypes = wizard.getElement("selTypes");
	var fileInput = wizard.getElement("txtPath");
	var feeds = wizard.getValue("feeds");
	var f = feeds[this.value];
	if(f) {
		selTypes.value = f.serverType;
		fileInput.value = f.url;
		this.selectedIndex = 0;
		wizard.setValue("feedName",f.serverType);
		wizard.setValue("feedHost",f.url);
		wizard.setValue("feedWorkspace",f.workspace);
		wizard.setValue("feedWorkspaceList",f.workspaceList);
		wizard.setValue("feedTiddlerFilter",f.tiddlerFilter);
	}
	return false;
};

config.macros.importTiddlers.onBrowseChange = function(e)
{
	var wizard = new Wizard(this);
	var fileInput = wizard.getElement("txtPath");
	fileInput.value = "file://" + this.value;
	var serverType = wizard.getElement("selTypes");
	serverType.value = "file";
	return false;
};

config.macros.importTiddlers.onOpen = function(e)
{
	var wizard = new Wizard(this);
	var fileInput = wizard.getElement("txtPath");
	var url = fileInput.value;
	var serverType = wizard.getElement("selTypes").value;
	var adaptor = new config.adaptors[serverType];
	wizard.setValue("adaptor",adaptor);
	wizard.setValue("serverType",serverType);
	wizard.setValue("host",url);
	var ret = adaptor.openHost(url,null,wizard,config.macros.importTiddlers.onOpenHost);
	if(ret !== true)
		displayMessage(ret);
	wizard.setButtons([{caption: config.macros.importTiddlers.cancelLabel, tooltip: config.macros.importTiddlers.cancelPrompt, onClick: config.macros.importTiddlers.onCancel}],config.macros.importTiddlers.statusOpenHost);
	return false;
};

config.macros.importTiddlers.onOpenHost = function(context,wizard)
{
	var adaptor = wizard.getValue("adaptor");
	if(context.status !== true)
		displayMessage("Error in importTiddlers.onOpenHost: " + context.statusText);
	// here he lists the tiddlers
	var ret = adaptor.getWorkspaceList(context,wizard,config.macros.importTiddlers.onGetWorkspaceList);
	if(ret !== true)
		displayMessage(ret);
	wizard.setButtons([{caption: config.macros.importTiddlers.cancelLabel, tooltip: config.macros.importTiddlers.cancelPrompt, onClick: config.macros.importTiddlers.onCancel}],config.macros.importTiddlers.statusGetWorkspaceList);
};

config.macros.importTiddlers.onGetWorkspaceList = function(context,wizard)
{
	if(context.status !== true)
		displayMessage("Error in importTiddlers.onGetWorkspaceList: " + context.statusText);
	wizard.setValue("context",context);
	var workspace = wizard.getValue("feedWorkspace");
	if(!workspace && context.workspaces.length==1)
		workspace = context.workspaces[0].title;
	if(workspace) {
		var ret = context.adaptor.openWorkspace(workspace,context,wizard,config.macros.importTiddlers.onOpenWorkspace);
		if(ret !== true)
			displayMessage(ret);
		wizard.setValue("workspace",workspace);
		wizard.setButtons([{caption: config.macros.importTiddlers.cancelLabel, tooltip: config.macros.importTiddlers.cancelPrompt, onClick: config.macros.importTiddlers.onCancel}],config.macros.importTiddlers.statusOpenWorkspace);
		return;
	}
	wizard.addStep(config.macros.importTiddlers.step2Title,config.macros.importTiddlers.step2Html);
	var s = wizard.getElement("selWorkspace");
	s.onchange = config.macros.importTiddlers.onWorkspaceChange;
	for(var t=0; t<context.workspaces.length; t++) {
		var e = createTiddlyElement(s,"option",null,null,context.workspaces[t].title);
		e.value = context.workspaces[t].title;
	}
	var workspaceList = wizard.getValue("feedWorkspaceList");
	if(workspaceList) {
		var list = workspaceList.parseParams("workspace",null,false,true);
		for(var n=1; n<list.length; n++) {
			if(context.workspaces.findByField("title",list[n].value) == null) {
				e = createTiddlyElement(s,"option",null,null,list[n].value);
				e.value = list[n].value;
			}
		}
	}
	if(workspace) {
		t = wizard.getElement("txtWorkspace");
		t.value = workspace;
	}
	wizard.setButtons([{caption: config.macros.importTiddlers.openLabel, tooltip: config.macros.importTiddlers.openPrompt, onClick: config.macros.importTiddlers.onChooseWorkspace}]);
};

config.macros.importTiddlers.onWorkspaceChange = function(e)
{
	var wizard = new Wizard(this);
	var t = wizard.getElement("txtWorkspace");
	t.value  = this.value;
	this.selectedIndex = 0;
	return false;
};

config.macros.importTiddlers.onChooseWorkspace = function(e)
{
	var wizard = new Wizard(this);
	var adaptor = wizard.getValue("adaptor");
	var workspace = wizard.getElement("txtWorkspace").value;
	wizard.setValue("workspace",workspace);
	var context = wizard.getValue("context");
	var ret = adaptor.openWorkspace(workspace,context,wizard,config.macros.importTiddlers.onOpenWorkspace);
	if(ret !== true)
		displayMessage(ret);
	wizard.setButtons([{caption: config.macros.importTiddlers.cancelLabel, tooltip: config.macros.importTiddlers.cancelPrompt, onClick: config.macros.importTiddlers.onCancel}],config.macros.importTiddlers.statusOpenWorkspace);
	return false;
};

config.macros.importTiddlers.onOpenWorkspace = function(context,wizard)
{
	if(context.status !== true)
		displayMessage("Error in importTiddlers.onOpenWorkspace: " + context.statusText);
	var adaptor = wizard.getValue("adaptor");
	var ret = adaptor.getTiddlerList(context,wizard,config.macros.importTiddlers.onGetTiddlerList,wizard.getValue("feedTiddlerFilter"));
	if(ret !== true)
		displayMessage(ret);
	wizard.setButtons([{caption: config.macros.importTiddlers.cancelLabel, tooltip: config.macros.importTiddlers.cancelPrompt, onClick: config.macros.importTiddlers.onCancel}],config.macros.importTiddlers.statusGetTiddlerList);
};

config.macros.importTiddlers.onGetTiddlerList = function(context,wizard)
{
	if(context.status !== true)
		displayMessage("Error in importTiddlers.onGetTiddlerList: " + context.statusText);
	// Extract data for the listview
	var listedTiddlers = [];
	if(context.tiddlers) {
		for(var n=0; n<context.tiddlers.length; n++) {
			var tiddler = context.tiddlers[n];
			listedTiddlers.push({
				title: tiddler.title,
				modified: tiddler.modified,
				modifier: tiddler.modifier,
				text: tiddler.text ? wikifyPlainText(tiddler.text,100) : "",
				tags: tiddler.tags,
				size: tiddler.text ? tiddler.text.length : 0,
				tiddler: tiddler
			});
		}
	}
	listedTiddlers.sort(function(a,b) {return a.title < b.title ? -1 : (a.title == b.title ? 0 : +1);});
	// Display the listview
	wizard.addStep(config.macros.importTiddlers.step3Title,config.macros.importTiddlers.step3Html);
	var markList = wizard.getElement("markList");
	var listWrapper = document.createElement("div");
	markList.parentNode.insertBefore(listWrapper,markList);
	var listView = ListView.create(listWrapper,listedTiddlers,config.macros.importTiddlers.listViewTemplate);
	wizard.setValue("listView",listView);
	var txtSaveTiddler = wizard.getElement("txtSaveTiddler");
	txtSaveTiddler.value = config.macros.importTiddlers.generateSystemServerName(wizard);
	wizard.setButtons([
			{caption: config.macros.importTiddlers.cancelLabel, tooltip: config.macros.importTiddlers.cancelPrompt, onClick: config.macros.importTiddlers.onCancel},
			{caption: config.macros.importTiddlers.importLabel, tooltip: config.macros.importTiddlers.importPrompt, onClick:  config.macros.importTiddlers.doImport}
		]);
};

config.macros.importTiddlers.generateSystemServerName = function(wizard)
{
	var serverType = wizard.getValue("serverType");
	var host = wizard.getValue("host");
	var workspace = wizard.getValue("workspace");
	var pattern = config.macros.importTiddlers[workspace ? "systemServerNamePattern" : "systemServerNamePatternNoWorkspace"];
	return pattern.format([serverType,host,workspace]);
};

config.macros.importTiddlers.saveServerTiddler = function(wizard)
{
	var txtSaveTiddler = wizard.getElement("txtSaveTiddler").value;
	if(store.tiddlerExists(txtSaveTiddler)) {
		if(!confirm(config.macros.importTiddlers.confirmOverwriteSaveTiddler.format([txtSaveTiddler])))
			return;
		store.suspendNotifications();
		store.removeTiddler(txtSaveTiddler);
		store.resumeNotifications();
	}
	var serverType = wizard.getValue("serverType");
	var host = wizard.getValue("host");
	var workspace = wizard.getValue("workspace");
	var text = config.macros.importTiddlers.serverSaveTemplate.format([serverType,host,workspace]);
	store.saveTiddler(txtSaveTiddler,txtSaveTiddler,text,config.macros.importTiddlers.serverSaveModifier,new Date(),["systemServer"]);
};

config.macros.importTiddlers.doImport = function(e)
{
	var wizard = new Wizard(this);
	if(wizard.getElement("chkSave").checked)
		config.macros.importTiddlers.saveServerTiddler(wizard);
	var chkSync = wizard.getElement("chkSync").checked;
	wizard.setValue("sync",chkSync);
	var listView = wizard.getValue("listView");
	var rowNames = ListView.getSelectedRows(listView);
	var adaptor = wizard.getValue("adaptor");
	var overwrite = new Array();
	var t;
	for(t=0; t<rowNames.length; t++) {
		if(store.tiddlerExists(rowNames[t]))
			overwrite.push(rowNames[t]);
	}
	if(overwrite.length > 0) {
		if(!confirm(config.macros.importTiddlers.confirmOverwriteText.format([overwrite.join(", ")])))
			return false;
	}
	wizard.addStep(config.macros.importTiddlers.step4Title.format([rowNames.length]),config.macros.importTiddlers.step4Html);
	for(t=0; t<rowNames.length; t++) {
		var link = document.createElement("div");
		createTiddlyLink(link,rowNames[t],true);
		var place = wizard.getElement("markReport");
		place.parentNode.insertBefore(link,place);
	}
	wizard.setValue("remainingImports",rowNames.length);
	wizard.setButtons([
			{caption: config.macros.importTiddlers.cancelLabel, tooltip: config.macros.importTiddlers.cancelPrompt, onClick: config.macros.importTiddlers.onCancel}
		],config.macros.importTiddlers.statusDoingImport);
	for(t=0; t<rowNames.length; t++) {
		var context = {};
		context.allowSynchronous = true;
		var inbound = adaptor.getTiddler(rowNames[t],context,wizard,config.macros.importTiddlers.onGetTiddler);
	}
	return false;
};

config.macros.importTiddlers.onGetTiddler = function(context,wizard)
{
	if(!context.status)
		displayMessage("Error in importTiddlers.onGetTiddler: " + context.statusText);
	var tiddler = context.tiddler;
	store.suspendNotifications();
	store.saveTiddler(tiddler.title, tiddler.title, tiddler.text, tiddler.modifier, tiddler.modified, tiddler.tags, tiddler.fields, true, tiddler.created);
	if(!wizard.getValue("sync")) {
		store.setValue(tiddler.title,'server',null);
	}
	store.resumeNotifications();
	if(!context.isSynchronous)
		store.notify(tiddler.title,true);
	var remainingImports = wizard.getValue("remainingImports")-1;
	wizard.setValue("remainingImports",remainingImports);
	if(remainingImports == 0) {
		if(context.isSynchronous) {
			store.notifyAll();
			refreshDisplay();
		}
		wizard.setButtons([
				{caption: config.macros.importTiddlers.doneLabel, tooltip: config.macros.importTiddlers.donePrompt, onClick: config.macros.importTiddlers.onCancel}
			],config.macros.importTiddlers.statusDoneImport);
		autoSaveChanges();
	}
};


//--
//-- UploadImportTiddlers macro
//--

config.macros.uploadImportTiddlers.handler = function(place,macroName,params,wikifier,paramString,tiddler)
{
	if(readOnly) {
		createTiddlyElement(place,"div",null,"marked",this.readOnlyWarning);
		return;
	}
	var w = new Wizard();
	w.createWizard(place,this.wizardTitle);
	this.restart(w);
};

config.macros.uploadImportTiddlers.onCancel = function(e)
{
	var wizard = new Wizard(this);
	var place = wizard.clear();
	config.macros.uploadImportTiddlers.restart(wizard);
	return false;
};

config.macros.uploadImportTiddlers.restart = function(wizard)
{
	wizard.addStep(this.step1Title,this.step1Html);
	wizard.setButtons([{caption: this.openLabel, tooltip: this.openPrompt, onClick: config.macros.uploadImportTiddlers.onOpen}]);
};

config.macros.uploadImportTiddlers.onOpen = function(e)
{
	var wizard = new Wizard(this);
	config.macros.uploadImportTiddlers.wizard = wizard;
	
	var iframe = document.getElementById('iframeUploadImport');
	iframe.onload = config.macros.uploadImportTiddlers.onUploadComplete;
	
	var form = wizard.getForm();
	form.action="upload.jsp";
	form.enctype="multipart/form-data";
	form.method="post";
	form.target="iframeUploadImport";
	form.submit();
	
	wizard.setButtons([{caption: config.macros.uploadImportTiddlers.cancelLabel, tooltip: config.macros.uploadImportTiddlers.cancelPrompt, onClick: config.macros.uploadImportTiddlers.onCancel}],config.macros.uploadImportTiddlers.statusOpenHost);
	return false;
};


config.macros.uploadImportTiddlers.onUploadComplete = function() {
	uploadImportHelper.getTiddlers(config.macros.uploadImportTiddlers.onGetTiddlersComplete);
}

config.macros.uploadImportTiddlers.onGetTiddlersComplete = function(tiddlers) {
	
	if (tiddlers && tiddlers.length){
		
		var storedTiddlers = [];
		var listedTiddlers = [];
		var datas = "";
			for(var n=0; n< tiddlers.length; n++) {
				var tiddler = tiddlers[n];
				datas += "|" + tiddler.modifiedString
				listedTiddlers.push({
					title: tiddler.title,
					modified: tiddler.modifiedString,
					modifier: tiddler.modifier,
					text: tiddler.encodedText ? wikifyPlainText(tiddler.encodedText,100) : "",
					tags: tiddler.tags,
					size: tiddler.encodedText ? tiddler.encodedText.length : 0,
					tiddler: tiddler
				});
				// store this here to find in the doImport
				storedTiddlers[tiddler.title] = tiddler;
				
		}
		
		config.macros.uploadImportTiddlers.tiddlers = storedTiddlers;
		
		wizard = config.macros.uploadImportTiddlers.wizard;
		listedTiddlers.sort(function(a,b) {return a.title < b.title ? -1 : (a.title == b.title ? 0 : +1);});
		// Display the listview
		wizard.addStep(config.macros.uploadImportTiddlers.step3Title,config.macros.uploadImportTiddlers.step3Html);
		var markList = wizard.getElement("markList");
		var listWrapper = document.createElement("div");
		markList.parentNode.insertBefore(listWrapper,markList);
		var listView = ListView.create(listWrapper,listedTiddlers,config.macros.uploadImportTiddlers.listViewTemplate);
		wizard.setValue("listView",listView);
		
		wizard.setButtons([
				{caption: config.macros.uploadImportTiddlers.cancelLabel, tooltip: config.macros.uploadImportTiddlers.cancelPrompt, onClick: config.macros.uploadImportTiddlers.onCancel},
				{caption: config.macros.uploadImportTiddlers.importLabel, tooltip: config.macros.uploadImportTiddlers.importPrompt, onClick:  config.macros.uploadImportTiddlers.doImport}
			]);
		
	} else {
		alert("Nothing to import...");
		config.macros.uploadImportTiddlers.restart(config.macros.uploadImportTiddlers.wizard);
	}
	
}

config.macros.uploadImportTiddlers.doImport = function(e)
{
	var wizard = new Wizard(this);

	var listView = wizard.getValue("listView");
	var rowNames = ListView.getSelectedRows(listView);
	var adaptor = wizard.getValue("adaptor");
	var overwrite = new Array();
	var t;
	for(t=0; t<rowNames.length; t++) {
		if(store.tiddlerExists(rowNames[t]))
			overwrite.push(rowNames[t]);
	}
	if(overwrite.length > 0) {
		if(!confirm(config.macros.uploadImportTiddlers.confirmOverwriteText.format([overwrite.join(", ")])))
			return false;
	}
	wizard.addStep(config.macros.uploadImportTiddlers.step4Title.format([rowNames.length]),config.macros.uploadImportTiddlers.step4Html);
	for(t=0; t<rowNames.length; t++) {
		var link = document.createElement("div");
		createTiddlyLink(link,rowNames[t],true);
		var place = wizard.getElement("markReport");
		place.parentNode.insertBefore(link,place);
	}
	wizard.setValue("remainingImports",rowNames.length);
	wizard.setButtons([
			{caption: config.macros.uploadImportTiddlers.cancelLabel, tooltip: config.macros.uploadImportTiddlers.cancelPrompt, onClick: config.macros.uploadImportTiddlers.onCancel}
		],config.macros.uploadImportTiddlers.statusDoingImport);
		
		
	for(t=0; t<rowNames.length; t++) {
		var context = {};
		context.allowSynchronous = true;

		var tiddler = config.macros.uploadImportTiddlers.tiddlers[rowNames[t]];
		
		store.suspendNotifications();
		
		var text = tiddler.encodedText.htmlDecode();
		if (text.indexOf("<pre>") == 0) {
			text = text.substring(5,text.length-"</pre>".length);
		} else {
			text = Tiddler.unescapeLineBreaks(tiddler.encodedText.htmlDecode());
		}
		
		store.saveTiddler(tiddler.title, tiddler.title, text, tiddler.modifier, (tiddler.modifiedString ? Date.convertFromYYYYMMDDHHMM(tiddler.modifiedString) : null), tiddler.tagsString, tiddler.fields, true, (tiddler.createdString ? Date.convertFromYYYYMMDDHHMM(tiddler.createdString) : null));

		if(!wizard.getValue("sync")) {
			store.setValue(tiddler.title,'server',null);
		}
		store.resumeNotifications();
		if(!context.isSynchronous)
			store.notify(tiddler.title,true);
		var remainingImports = wizard.getValue("remainingImports")-1;
		wizard.setValue("remainingImports",remainingImports);
		if(remainingImports == 0) {
			if(context.isSynchronous) {
				store.notifyAll();
				refreshDisplay();
			}
			wizard.setButtons([
					{caption: config.macros.uploadImportTiddlers.doneLabel, tooltip: config.macros.uploadImportTiddlers.donePrompt, onClick: config.macros.uploadImportTiddlers.onCancel}
				],config.macros.uploadImportTiddlers.statusDoneImport);
			autoSaveChanges();
		}
		
		
	}
	return false;
};

//--
//-- Sync macro
//--

// Synchronisation handlers
config.syncers = {};

// Sync state.
var currSync = null;

// sync macro
config.macros.sync.handler = function(place,macroName,params,wikifier,paramString,tiddler)
{
	if(!wikifier.isStatic)
		this.startSync(place);
};

config.macros.sync.startSync = function(place)
{
	if(currSync)
		config.macros.sync.cancelSync();
	currSync = {};
	currSync.syncList = this.getSyncableTiddlers();
	this.createSyncTasks();
	this.preProcessSyncableTiddlers();
	var wizard = new Wizard();
	currSync.wizard = wizard;
	wizard.createWizard(place,this.wizardTitle);
	wizard.addStep(this.step1Title,this.step1Html);
	var markList = wizard.getElement("markList");
	var listWrapper = document.createElement("div");
	markList.parentNode.insertBefore(listWrapper,markList);
	currSync.listView = ListView.create(listWrapper,currSync.syncList,this.listViewTemplate);
	this.processSyncableTiddlers();
	wizard.setButtons([
			{caption: this.syncLabel, tooltip: this.syncPrompt, onClick: this.doSync}
		]);
};

config.macros.sync.getSyncableTiddlers = function()
{
	var list = [];
	store.forEachTiddler(function(title,tiddler) {
		var syncItem = {};
		syncItem.serverType = tiddler.getServerType();
		syncItem.serverHost = tiddler.fields['server.host'];
		syncItem.serverWorkspace = tiddler.fields['server.workspace'];
		syncItem.tiddler = tiddler;
		syncItem.title = tiddler.title;
		syncItem.isTouched = tiddler.isTouched();
		syncItem.selected = syncItem.isTouched;
		syncItem.syncStatus = config.macros.sync.syncStatusList[syncItem.isTouched ? "changedLocally" : "none"];
		syncItem.status = syncItem.syncStatus.text;
		if(syncItem.serverType && syncItem.serverHost)
			list.push(syncItem);
		});
	list.sort(function(a,b) {return a.title < b.title ? -1 : (a.title == b.title ? 0 : +1);});
	return list;
};

config.macros.sync.preProcessSyncableTiddlers = function()
{
	for(var t=0; t<currSync.syncList.length; t++) {
		si = currSync.syncList[t];
		var ti = si.syncTask.syncMachine.generateTiddlerInfo(si.tiddler);
		si.serverUrl = ti.uri;
	}
};

config.macros.sync.processSyncableTiddlers = function()
{
	for(var t=0; t<currSync.syncList.length; t++) {
		si = currSync.syncList[t];
		si.rowElement.style.backgroundColor = si.syncStatus.color;
	}
};

config.macros.sync.createSyncTasks = function()
{
	currSync.syncTasks = [];
	for(var t=0; t<currSync.syncList.length; t++) {
		var si = currSync.syncList[t];
		var r = null;
		for(var st=0; st<currSync.syncTasks.length; st++) {
			var cst = currSync.syncTasks[st];
			if(si.serverType == cst.serverType && si.serverHost == cst.serverHost && si.serverWorkspace == cst.serverWorkspace)
				r = cst;
		}
		if(r == null) {
			si.syncTask = this.createSyncTask(si);
			currSync.syncTasks.push(si.syncTask);
		} else {
			si.syncTask = r;
			r.syncItems.push(si);
		}
	}
};

config.macros.sync.createSyncTask = function(syncItem)
{
	var st = {};
	st.serverType = syncItem.serverType;
	st.serverHost = syncItem.serverHost;
	st.serverWorkspace = syncItem.serverWorkspace;
	st.syncItems = [syncItem];
	st.syncMachine = new SyncMachine(st.serverType,{
		start: function() {
			return this.openHost(st.serverHost,"openWorkspace");
		},
		openWorkspace: function() {
			return this.openWorkspace(st.serverWorkspace,"getTiddlerList");
		},
		getTiddlerList: function() {
			return this.getTiddlerList("onGetTiddlerList");
		},
		onGetTiddlerList: function(context) {
			var tiddlers = context.tiddlers;
			for(var t=0; t<st.syncItems.length; t++) {
				var si = st.syncItems[t];
				var f = tiddlers.findByField("title",si.title);
				if(f !== null) {
					if(tiddlers[f].fields['server.page.revision'] > si.tiddler.fields['server.page.revision']) {
						si.syncStatus = config.macros.sync.syncStatusList[si.isTouched ? 'changedBoth' : 'changedServer'];
					}
				} else {
					si.syncStatus = config.macros.sync.syncStatusList.notFound;
				}
				config.macros.sync.updateSyncStatus(si);
			}
		},
		getTiddler: function(title) {
			return this.getTiddler(title,"onGetTiddler");
		},
		onGetTiddler: function(context) {
			var tiddler = context.tiddler;
			var syncItem = st.syncItems.findByField("title",tiddler.title);
			if(syncItem !== null) {
				syncItem = st.syncItems[syncItem];
				store.saveTiddler(tiddler.title, tiddler.title, tiddler.text, tiddler.modifier, tiddler.modified, tiddler.tags, tiddler.fields, true, tiddler.created);
				syncItem.syncStatus = config.macros.sync.syncStatusList.gotFromServer;
				config.macros.sync.updateSyncStatus(syncItem);
			}
		},
		putTiddler: function(tiddler) {
			return this.putTiddler(tiddler,"onPutTiddler");
		},
		onPutTiddler: function(context) {
			var title = context.title;
			var syncItem = st.syncItems.findByField("title",title);
			if(syncItem !== null) {
				syncItem = st.syncItems[syncItem];
				store.resetTiddler(title);
				syncItem.syncStatus = config.macros.sync.syncStatusList.putToServer;
				config.macros.sync.updateSyncStatus(syncItem);
			}
		}
	});
	st.syncMachine.go();
	return st;
};

config.macros.sync.updateSyncStatus = function(syncItem)
{
	var e = syncItem.colElements["status"];
	removeChildren(e);
	createTiddlyText(e,syncItem.syncStatus.text);
	syncItem.rowElement.style.backgroundColor = syncItem.syncStatus.color;
};

config.macros.sync.doSync = function(e)
{
	var rowNames = ListView.getSelectedRows(currSync.listView);
	for(var t=0; t<currSync.syncList.length; t++) {
		var si = currSync.syncList[t];
		if(rowNames.indexOf(si.title) != -1) {
			config.macros.sync.doSyncItem(si);
		}
	}
	return false;
};

config.macros.sync.doSyncItem = function(syncItem)
{
	var r = true;
	var sl = config.macros.sync.syncStatusList;
	switch(syncItem.syncStatus) {
		case sl.changedServer:
			r = syncItem.syncTask.syncMachine.go("getTiddler",syncItem.title);
			break;
		case sl.notFound:
		case sl.changedLocally:
		case sl.changedBoth:
			r = syncItem.syncTask.syncMachine.go("putTiddler",syncItem.tiddler);
			break;
		default:
			break;
	}
	if(r !== true)
		displayMessage("Error in doSyncItem: " + r);
};

config.macros.sync.cancelSync = function()
{
	currSync = null;
};

function SyncMachine(serverType,steps)
{
	this.serverType = serverType;
	this.adaptor = new config.adaptors[serverType];
	this.steps = steps;
}

SyncMachine.prototype.go = function(step,context)
{
	var r = context ? context.status : null;
	if(typeof r == "string") {
		this.invokeError(r);
		return r;
	}
	var h = this.steps[step ? step : "start"];
	if(!h)
		return null;
	r = h.call(this,context);
	if(typeof r == "string")
		this.invokeError(r);
	return r;
};

SyncMachine.prototype.invokeError = function(message)
{
	if(this.steps.error)
		this.steps.error(message);
};

SyncMachine.prototype.openHost = function(host,nextStep)
{
	var me = this;
	return me.adaptor.openHost(host,null,null,function(context) {me.go(nextStep,context);});
};

SyncMachine.prototype.getWorkspaceList = function(nextStep)
{
	var me = this;
	return me.adaptor.getWorkspaceList(null,null,function(context) {me.go(nextStep,context);});
};

SyncMachine.prototype.openWorkspace = function(workspace,nextStep)
{
	var me = this;
	return me.adaptor.openWorkspace(workspace,null,null,function(context) {me.go(nextStep,context);});
};

SyncMachine.prototype.getTiddlerList = function(nextStep)
{
	var me = this;
	return me.adaptor.getTiddlerList(null,null,function(context) {me.go(nextStep,context);});
};

SyncMachine.prototype.generateTiddlerInfo = function(tiddler)
{
	return this.adaptor.generateTiddlerInfo(tiddler);
};

SyncMachine.prototype.getTiddler = function(title,nextStep)
{
	var me = this;
	return me.adaptor.getTiddler(title,null,null,function(context) {me.go(nextStep,context);});
};

SyncMachine.prototype.putTiddler = function(tiddler,nextStep)
{
	var me = this;
	return me.adaptor.putTiddler(tiddler,null,null,function(context) {me.go(nextStep,context);});
};

//--
//-- Manager UI for groups of tiddlers
//--

config.macros.plugins.handler = function(place,macroName,params,wikifier,paramString,tiddler)
{
	var wizard = new Wizard();
	wizard.createWizard(place,this.wizardTitle);
	wizard.addStep(this.step1Title,this.step1Html);
	var markList = wizard.getElement("markList");
	var listWrapper = document.createElement("div");
	markList.parentNode.insertBefore(listWrapper,markList);
	listWrapper.setAttribute("refresh","macro");
	listWrapper.setAttribute("macroName","plugins");
	listWrapper.setAttribute("params",paramString);
	this.refresh(listWrapper,paramString);
};

config.macros.plugins.refresh = function(listWrapper,params)
{
	var wizard = new Wizard(listWrapper);
	var selectedRows = [];
	ListView.forEachSelector(listWrapper,function(e,rowName) {
			if(e.checked)
				selectedRows.push(e.getAttribute("rowName"));
		});
	removeChildren(listWrapper);
	params = params.parseParams("anon");
	var plugins = installedPlugins.slice(0);
	var t,tiddler,p;
	var configTiddlers = store.getTaggedTiddlers("systemConfig");
	for(t=0; t<configTiddlers.length; t++) {
		tiddler = configTiddlers[t];
		if(plugins.findByField("title",tiddler.title) == null) {
			p = getPluginInfo(tiddler);
			p.executed = false;
			p.log.splice(0,0,this.skippedText);
			plugins.push(p);
		}
	}
	for(t=0; t<plugins.length; t++) {
		p = plugins[t];
		p.size = p.tiddler.text ? p.tiddler.text.length : 0;
		p.forced = p.tiddler.isTagged("systemConfigForce");
		p.disabled = p.tiddler.isTagged("systemConfigDisable");
		p.Selected = selectedRows.indexOf(plugins[t].title) != -1;
	}
	if(plugins.length == 0) {
		createTiddlyElement(listWrapper,"em",null,null,this.noPluginText);
		wizard.setButtons([]);
	} else {
		var listView = ListView.create(listWrapper,plugins,this.listViewTemplate,this.onSelectCommand);
		wizard.setValue("listView",listView);
		wizard.setButtons([
				{caption: config.macros.plugins.removeLabel, tooltip: config.macros.plugins.removePrompt, onClick:  config.macros.plugins.doRemoveTag},
				{caption: config.macros.plugins.deleteLabel, tooltip: config.macros.plugins.deletePrompt, onClick:  config.macros.plugins.doDelete}
			]);
	}
};

config.macros.plugins.doRemoveTag = function(e)
{
	var wizard = new Wizard(this);
	var listView = wizard.getValue("listView");
	var rowNames = ListView.getSelectedRows(listView);
	if(rowNames.length == 0) {
		alert(config.messages.nothingSelected);
	} else {
		for(var t=0; t<rowNames.length; t++)
			store.setTiddlerTag(rowNames[t],false,"systemConfig");
	}
};

config.macros.plugins.doDelete = function(e)
{
	var wizard = new Wizard(this);
	var listView = wizard.getValue("listView");
	var rowNames = ListView.getSelectedRows(listView);
	if(rowNames.length == 0) {
		alert(config.messages.nothingSelected);
	} else {
		if(confirm(config.macros.plugins.confirmDeleteText.format([rowNames.join(", ")]))) {
			for(t=0; t<rowNames.length; t++) {
				store.removeTiddler(rowNames[t]);
				story.closeTiddler(rowNames[t],true);
			}
		}
	}
};

//--
//-- Message area
//--

function getMessageDiv()
{
	var msgArea = document.getElementById("messageArea");
	if(!msgArea)
		return null;
	if(!msgArea.hasChildNodes())
		createTiddlyButton(createTiddlyElement(msgArea,"div",null,"messageToolbar"),
			config.messages.messageClose.text,
			config.messages.messageClose.tooltip,
			clearMessage);
	msgArea.style.display = "block";
	return createTiddlyElement(msgArea,"div");
}

function displayMessage(text,linkText)
{
	var e = getMessageDiv();
	if(!e) {
		alert(text);
		return;
	}
	if(linkText) {
		var link = createTiddlyElement(e,"a",null,null,text);
		link.href = linkText;
		link.target = "_blank";
	} else {
		e.appendChild(document.createTextNode(text));
	}
}

function clearMessage()
{
	var msgArea = document.getElementById("messageArea");
	if(msgArea) {
		removeChildren(msgArea);
		msgArea.style.display = "none";
	}
	return false;
}

//--
//-- Refresh mechanism
//--

config.refreshers = {
	link: function(e,changeList)
		{
		var title = e.getAttribute("tiddlyLink");
		refreshTiddlyLink(e,title);
		return true;
		},

	tiddler: function(e,changeList)
		{
		var title = e.getAttribute("tiddler");
		var template = e.getAttribute("template");
		if(changeList && changeList.indexOf(title) != -1 && !story.isDirty(title))
			story.refreshTiddler(title,template,true);
		else
			refreshElements(e,changeList);
		return true;
		},

	content: function(e,changeList)
		{
		var title = e.getAttribute("tiddler");
		var force = e.getAttribute("force");
		if(force != null || changeList == null || changeList.indexOf(title) != -1) {
			removeChildren(e);
			wikify(store.getTiddlerText(title,title),e,null);
			return true;
		} else
			return false;
		},

	macro: function(e,changeList)
		{
		var macro = e.getAttribute("macroName");
		var params = e.getAttribute("params");
		if(macro)
			macro = config.macros[macro];
		if(macro && macro.refresh)
			macro.refresh(e,params);
		return true;
		},
	styleSheet: "StyleSheet", 
	defaultStyleSheet: "StyleSheet", 
	pageTemplate: "PageTemplate", 
	defaultPageTemplate: "PageTemplate", 
	colorPalette: "ColorPalette", 
	defaultColorPalette: "ColorPalette" 
};

function refreshElements(root,changeList)
{
	var nodes = root.childNodes;
	for(var c=0; c<nodes.length; c++) {
		var e = nodes[c], type = null;
		if(e.getAttribute  && (e.tagName ? e.tagName != "IFRAME" : true))
			type = e.getAttribute("refresh");
		var refresher = config.refreshers[type];
		var refreshed = false;
		if(refresher != undefined)
			refreshed = refresher(e,changeList);
		if(e.hasChildNodes() && !refreshed)
			refreshElements(e,changeList);
	}
}

function applyHtmlMacros(root,tiddler)
{
	var e = root.firstChild;
	while(e) {
		var nextChild = e.nextSibling;
		if(e.getAttribute) {
			var macro = e.getAttribute("macro");
			if(macro) {
				var params = "";
				var p = macro.indexOf(" ");
				if(p != -1) {
					params = macro.substr(p+1);
					macro = macro.substr(0,p);
				}
				invokeMacro(e,macro,params,null,tiddler);
			}
		}
		if(e.hasChildNodes())
			applyHtmlMacros(e,tiddler);
		e = nextChild;
	}
}

function refreshPageTemplate(title)
{
	var stash = createTiddlyElement(document.body,"div");
	stash.style.display = "none";
	var display = document.getElementById("tiddlerDisplay");
	var nodes,t;
	if(display) {
		nodes = display.childNodes;
		for(t=nodes.length-1; t>=0; t--)
			stash.appendChild(nodes[t]);
	}
	var wrapper = document.getElementById("contentWrapper");

	isAvailable = function(title) { 
		var s = title ? title.indexOf(config.textPrimitives.sectionSeparator) : -1; 
		if(s!=-1) 
			title = title.substr(0,s); 
		return store.tiddlerExists(title) || store.isShadowTiddler(title); 
 	};
	if(!title || !isAvailable(title))
		title = config.refreshers.pageTemplate;
	if(!isAvailable(title))
		title = config.refreshers.defaultPageTemplate; //# this one is always avaialable
	html = store.getRecursiveTiddlerText(title,null,10);
	wrapper.innerHTML = html;
	applyHtmlMacros(wrapper);
	refreshElements(wrapper);
	display = document.getElementById("tiddlerDisplay");
	removeChildren(display);
	if(!display)
		display = createTiddlyElement(wrapper,"div","tiddlerDisplay");
	nodes = stash.childNodes;
	for(t=nodes.length-1; t>=0; t--)
		display.appendChild(nodes[t]);
	removeNode(stash);
}

function refreshDisplay(hint)
{
	if(typeof hint == "string")
		hint = [hint];
	var e = document.getElementById("contentWrapper");
	refreshElements(e,hint);
	if(backstage.isPanelVisible()) {
		e = document.getElementById("backstage");
		refreshElements(e,hint);
	}
}

function refreshPageTitle()
{
	document.title = getPageTitle();
}

function getPageTitle()
{
	var st = wikifyPlain("SiteTitle");
	var ss = wikifyPlain("SiteSubtitle");
	return st + ((st == "" || ss == "") ? "" : " - ") + ss;
}

function refreshStyles(title,doc)
{
	setStylesheet(title == null ? "" : store.getRecursiveTiddlerText(title,"",10),title,doc ? doc : document);
}

function refreshColorPalette(title)
{
	if(!startingUp)
		refreshAll();
}

function refreshAll()
{
	refreshPageTemplate();
	refreshDisplay();
	refreshStyles("StyleSheetLayout");
	refreshStyles("StyleSheetColors");
	refreshStyles(config.refreshers.styleSheet);
	refreshStyles("StyleSheetPrint");
}

//--
//-- Options stuff
//--

config.optionHandlers = {
	'txt': {
		get: function(name) {return encodeCookie(config.options[name].toString());},
		set: function(name,value) {config.options[name] = decodeCookie(value);}
	},
	'chk': {
		get: function(name) {return config.options[name] ? "true" : "false";},
		set: function(name,value) {config.options[name] = value == "true";}
	}
};

function loadOptionsCookie()
{
	if(safeMode)
		return;
	var cookies = document.cookie.split(";");
	for(var c=0; c<cookies.length; c++) {
		var p = cookies[c].indexOf("=");
		if(p != -1) {
			var name = cookies[c].substr(0,p).trim();
			var value = cookies[c].substr(p+1).trim();
			var optType = name.substr(0,3);
			if(config.optionHandlers[optType] && config.optionHandlers[optType].set)
				config.optionHandlers[optType].set(name,value);
		}
	}
}

function saveOptionCookie(name)
{
	if(safeMode)
		return;
	var c = name + "=";
	var optType = name.substr(0,3);
	if(config.optionHandlers[optType] && config.optionHandlers[optType].get)
		c += config.optionHandlers[optType].get(name);
	c += "; expires=Fri, 1 Jan 2038 12:00:00 UTC; path=/";
	document.cookie = c;
}

function encodeCookie(s)
{
	return escape(manualConvertUnicodeToUTF8(s));
}

function decodeCookie(s)
{
	s = unescape(s);
	var re = /&#[0-9]{1,5};/g;
	return s.replace(re,function($0) {return String.fromCharCode(eval($0.replace(/[&#;]/g,"")));});
}


config.macros.option.genericCreate = function(place,type,opt,className,desc)
{
	var typeInfo = config.macros.option.types[type];
	var c = document.createElement(typeInfo.elementType);
	if(typeInfo.typeValue)
		c.setAttribute("type",typeInfo.typeValue);
	c[typeInfo.eventName] = typeInfo.onChange;
	c.setAttribute("option",opt);
	if(className)
		c.className = className;
	else
		c.className = typeInfo.className;
	if(config.optionsDesc[opt])
		c.setAttribute("title",config.optionsDesc[opt]);
	place.appendChild(c);
	if(desc != "no")
		createTiddlyText(place,config.optionsDesc[opt] ? config.optionsDesc[opt] : opt);
	c[typeInfo.valueField] = config.options[opt];
	return c;
};

config.macros.option.genericOnChange = function(e)
{
	var opt = this.getAttribute("option");
	if(opt) {
		var optType = opt.substr(0,3);
		var handler = config.macros.option.types[optType];
		if (handler.elementType && handler.valueField)
			config.macros.option.propagateOption(opt,handler.valueField,this[handler.valueField],handler.elementType);
		}
	return true;
};

config.macros.option.types = {
	'txt': {
		elementType: "input",
		valueField: "value",
		eventName: "onkeyup",
		className: "txtOptionInput",
		create: config.macros.option.genericCreate,
		onChange: config.macros.option.genericOnChange
	},
	'chk': {
		elementType: "input",
		valueField: "checked",
		eventName: "onclick",
		className: "chkOptionInput",
		typeValue: "checkbox",
		create: config.macros.option.genericCreate,
		onChange: config.macros.option.genericOnChange
	}
};

config.macros.option.propagateOption = function(opt,valueField,value,elementType)
{
	config.options[opt] = value;
	saveOptionCookie(opt);
	var nodes = document.getElementsByTagName(elementType);
	for(var t=0; t<nodes.length; t++) {
		var optNode = nodes[t].getAttribute("option");
		if(opt == optNode)
			nodes[t][valueField] = value;
		}
};

config.macros.option.handler = function(place,macroName,params,wikifier,paramString,tiddler)
{
	params = paramString.parseParams("anon",null,true,false,false);
	var opt = (params[1] && params[1].name == "anon") ? params[1].value : getParam(params,"name",null);
	var className = (params[2] && params[2].name == "anon") ? params[2].value : getParam(params,"class",null);
	var desc = getParam(params,"desc","no");
	var type = opt.substr(0,3);
	var h = config.macros.option.types[type];
	if (h && h.create)
		h.create(place,type,opt,className,desc);
};

config.macros.options.handler = function(place,macroName,params,wikifier,paramString,tiddler)
{
	params = paramString.parseParams("anon",null,true,false,false);
	var showUnknown = getParam(params,"showUnknown","no");
	var wizard = new Wizard();
	wizard.createWizard(place,this.wizardTitle);
	wizard.addStep(this.step1Title,this.step1Html);
	var markList = wizard.getElement("markList");
	var chkUnknown = wizard.getElement("chkUnknown");
	chkUnknown.checked = showUnknown == "yes";
	chkUnknown.onchange = this.onChangeUnknown;
	var listWrapper = document.createElement("div");
	markList.parentNode.insertBefore(listWrapper,markList);
	wizard.setValue("listWrapper",listWrapper);
	this.refreshOptions(listWrapper,showUnknown == "yes");
};

config.macros.options.refreshOptions = function(listWrapper,showUnknown)
{
	var opts = [];
	for(var n in config.options) {
		var opt = {};
		opt.option = "";
		opt.name = n;
		opt.lowlight = !config.optionsDesc[n];
		opt.description = opt.lowlight ? this.unknownDescription : config.optionsDesc[n];
		if(!opt.lowlight || showUnknown)
			opts.push(opt);
	}
	opts.sort(function(a,b) {return a.name.substr(3) < b.name.substr(3) ? -1 : (a.name.substr(3) == b.name.substr(3) ? 0 : +1);});
	var listview = ListView.create(listWrapper,opts,this.listViewTemplate);
	for(n=0; n<opts.length; n++) {
		var type = opts[n].name.substr(0,3);
		var h = config.macros.option.types[type];
		if (h && h.create) {
			h.create(opts[n].colElements['option'],type,opts[n].name,null,"no");
		}
	}
};

config.macros.options.onChangeUnknown = function(e)
{
	var wizard = new Wizard(this);
	var listWrapper = wizard.getValue("listWrapper");
	removeChildren(listWrapper);
	config.macros.options.refreshOptions(listWrapper,this.checked);
	return false;
};

//--
//-- Saving
//--

var saveUsingSafari = false;

var startSaveArea = '<div id="' + 'storeArea">'; // Split up into two so that indexOf() of this source doesn't find it
var endSaveArea = '</d' + 'iv>';

// If there are unsaved changes, force the user to confirm before exitting
function confirmExit()
{
	hadConfirmExit = true;
	if((store && store.isDirty && store.isDirty()) || (story && story.areAnyDirty && story.areAnyDirty()))
		return config.messages.confirmExit;
}

// Give the user a chance to save changes before exitting
function checkUnsavedChanges()
{
	if(store && store.isDirty && store.isDirty() && window.hadConfirmExit === false) {
		if(confirm(config.messages.unsavedChangesWarning))
			saveChanges();
	}
}

function updateLanguageAttribute(s)
{
	if(config.locale) {
		var mRE = /(<html(?:.*?)?)(?: xml:lang\="([a-z]+)")?(?: lang\="([a-z]+)")?>/;
		var m = mRE.exec(s);
		if(m) {
			var t = m[1];
			if(m[2])
				t += ' xml:lang="' + config.locale + '"';
			if(m[3])
				t += ' lang="' + config.locale + '"';
			t += ">";
			s = s.substr(0,m.index) + t + s.substr(m.index+m[0].length);
		}
	}
	return s;
}

function updateMarkupBlock(s,blockName,tiddlerName)
{
	return s.replaceChunk(
			"<!--%0-START-->".format([blockName]),
			"<!--%0-END-->".format([blockName]),
			"\n" + store.getRecursiveTiddlerText(tiddlerName,"") + "\n");
}

function updateOriginal(original,posDiv)
{
	if(!posDiv)
		posDiv = locateStoreArea(original);
	if(!posDiv) {
		alert(config.messages.invalidFileError.format([localPath]));
		return null;
	}
	var revised = original.substr(0,posDiv[0] + startSaveArea.length) + "\n" +
				convertUnicodeToUTF8(store.allTiddlersAsHtml()) + "\n" +
				original.substr(posDiv[1]);
	var newSiteTitle = convertUnicodeToUTF8(getPageTitle()).htmlEncode();
	revised = revised.replaceChunk("<title"+">","</title"+">"," " + newSiteTitle + " ");
	revised = updateLanguageAttribute(revised);
	revised = updateMarkupBlock(revised,"PRE-HEAD","MarkupPreHead");
	revised = updateMarkupBlock(revised,"POST-HEAD","MarkupPostHead");
	revised = updateMarkupBlock(revised,"PRE-BODY","MarkupPreBody");
	revised = updateMarkupBlock(revised,"POST-SCRIPT","MarkupPostBody");
	return revised;
}

function locateStoreArea(original)
{
	// Locate the storeArea div's
	var posOpeningDiv = original.indexOf(startSaveArea);
	var limitClosingDiv = original.indexOf("<"+"!--POST-STOREAREA--"+">");
	if(limitClosingDiv == -1)
		limitClosingDiv = original.indexOf("<"+"!--POST-BODY-START--"+">");
	var posClosingDiv = original.lastIndexOf(endSaveArea,limitClosingDiv == -1 ? original.length : limitClosingDiv);
	return (posOpeningDiv != -1 && posClosingDiv != -1) ? [posOpeningDiv,posClosingDiv] : null;
}

function autoSaveChanges(onlyIfDirty,tiddlers)
{
	if(config.options.chkAutoSave)
		saveChanges(onlyIfDirty,tiddlers);
}

// Save this tiddlywiki with the pending changes
function saveChanges(onlyIfDirty,tiddlers)
{
	if(onlyIfDirty && !store.isDirty())
		return;
	clearMessage();
	// Get the URL of the document
	var originalPath = document.location.toString();
	// Check we were loaded from a file URL
	if(originalPath.substr(0,5) != "file:") {
		alert(config.messages.notFileUrlError);
		if(store.tiddlerExists(config.messages.saveInstructions))
			story.displayTiddler(null,config.messages.saveInstructions);
		return;
	}
	var localPath = getLocalPath(originalPath);
	// Load the original file
	var original = loadFile(localPath);
	if(original == null) {
		alert(config.messages.cantSaveError);
		if(store.tiddlerExists(config.messages.saveInstructions))
			story.displayTiddler(null,config.messages.saveInstructions);
		return;
	}
	// Locate the storeArea div's
	var posDiv = locateStoreArea(original);
	if(!posDiv) {
		alert(config.messages.invalidFileError.format([localPath]));
		return;
	}
	saveBackup(localPath,original);
	saveRss(localPath);
	saveEmpty(localPath,original,posDiv);
	saveMain(localPath,original,posDiv);
}

function saveBackup(localPath,original)
{
	if(config.options.chkSaveBackups) {
		var backupPath = getBackupPath(localPath);
		var backup = config.browser.isIE ? ieCopyFile(backupPath,localPath) : saveFile(backupPath,original);
		if(backup)
			displayMessage(config.messages.backupSaved,"file://" + backupPath);
		else
			alert(config.messages.backupFailed);
	}
}

function saveRss(localPath)
{
	if(config.options.chkGenerateAnRssFeed) {
		var rssPath = localPath.substr(0,localPath.lastIndexOf(".")) + ".xml";
		var rssSave = saveFile(rssPath,convertUnicodeToUTF8(generateRss()));
		if(rssSave)
			displayMessage(config.messages.rssSaved,"file://" + rssPath);
		else
			alert(config.messages.rssFailed);
	}
}

function saveEmpty(localPath,original,posDiv)
{
	if(config.options.chkSaveEmptyTemplate) {
		var emptyPath,p;
		if((p = localPath.lastIndexOf("/")) != -1)
			emptyPath = localPath.substr(0,p) + "/empty.html";
		else if((p = localPath.lastIndexOf("\\")) != -1)
			emptyPath = localPath.substr(0,p) + "\\empty.html";
		else
			emptyPath = localPath + ".empty.html";
		var empty = original.substr(0,posDiv[0] + startSaveArea.length) + original.substr(posDiv[1]);
		var emptySave = saveFile(emptyPath,empty);
		if(emptySave)
			displayMessage(config.messages.emptySaved,"file://" + emptyPath);
		else
			alert(config.messages.emptyFailed);
	}
}

function saveMain(localPath,original,posDiv)
{
	var save;
	try {
		var revised = updateOriginal(original,posDiv);
		save = saveFile(localPath,revised);
	} catch (ex) {
		showException(ex);
	}
	if(save) {
		displayMessage(config.messages.mainSaved,"file://" + localPath);
		store.setDirty(false);
	} else {
		alert(config.messages.mainFailed);
	}
}

function getLocalPath(origPath)
{
	var originalPath = convertUriToUTF8(origPath,config.options.txtFileSystemCharSet);
	// Remove any location or query part of the URL
	var argPos = originalPath.indexOf("?");
	if(argPos != -1)
		originalPath = originalPath.substr(0,argPos);
	var hashPos = originalPath.indexOf("#");
	if(hashPos != -1)
		originalPath = originalPath.substr(0,hashPos);
	// Convert file://localhost/ to file:///
	if(originalPath.indexOf("file://localhost/") == 0)
		originalPath = "file://" + originalPath.substr(16);
	// Convert to a native file format
	var localPath;
	if(originalPath.charAt(9) == ":") // pc local file
		localPath = unescape(originalPath.substr(8)).replace(new RegExp("/","g"),"\\");
	else if(originalPath.indexOf("file://///") == 0) // FireFox pc network file
		localPath = "\\\\" + unescape(originalPath.substr(10)).replace(new RegExp("/","g"),"\\");
	else if(originalPath.indexOf("file:///") == 0) // mac/unix local file
		localPath = unescape(originalPath.substr(7));
	else if(originalPath.indexOf("file:/") == 0) // mac/unix local file
		localPath = unescape(originalPath.substr(5));
	else // pc network file
		localPath = "\\\\" + unescape(originalPath.substr(7)).replace(new RegExp("/","g"),"\\");
	return localPath;
}

function getBackupPath(localPath,title,extension)
{
	var slash = "\\";
	var dirPathPos = localPath.lastIndexOf("\\");
	if(dirPathPos == -1) {
		dirPathPos = localPath.lastIndexOf("/");
		slash = "/";
	}
	var backupFolder = config.options.txtBackupFolder;
	if(!backupFolder || backupFolder == "")
		backupFolder = ".";
	var backupPath = localPath.substr(0,dirPathPos) + slash + backupFolder + localPath.substr(dirPathPos);
	backupPath = backupPath.substr(0,backupPath.lastIndexOf(".")) + ".";
	if(title)
		backupPath += title.replace(/[\\\/\*\?\":<> ]/g,"_") + ".";
	backupPath += (new Date()).convertToYYYYMMDDHHMMSSMMM() + "." + (extension ? extension : "html");
	return backupPath;
}

function generateRss()
{
	var s = [];
	var d = new Date();
	var u = store.getTiddlerText("SiteUrl");
	// Assemble the header
	s.push("<" + "?xml version=\"1.0\"?" + ">");
	s.push("<rss version=\"2.0\">");
	s.push("<channel>");
	s.push("<title" + ">" + wikifyPlain("SiteTitle").htmlEncode() + "</title" + ">");
	if(u)
		s.push("<link>" + u.htmlEncode() + "</link>");
	s.push("<description>" + wikifyPlain("SiteSubtitle").htmlEncode() + "</description>");
	s.push("<language>en-us</language>");
	s.push("<copyright>Copyright " + d.getFullYear() + " " + config.options.txtUserName.htmlEncode() + "</copyright>");
	s.push("<pubDate>" + d.toGMTString() + "</pubDate>");
	s.push("<lastBuildDate>" + d.toGMTString() + "</lastBuildDate>");
	s.push("<docs>http://blogs.law.harvard.edu/tech/rss</docs>");
	s.push("<generator>TiddlyWiki " + version.major + "." + version.minor + "." + version.revision + "</generator>");
	// The body
	var tiddlers = store.getTiddlers("modified","excludeLists");
	var n = config.numRssItems > tiddlers.length ? 0 : tiddlers.length-config.numRssItems;
	for (var t=tiddlers.length-1; t>=n; t--) {
		s.push("<item>\n" + tiddlers[t].toRssItem(u) + "\n</item>");
	}
	// And footer
	s.push("</channel>");
	s.push("</rss>");
	// Save it all
	return s.join("\n");
}

//--
//-- Filesystem code
//--

function convertUTF8ToUnicode(u)
{
	return window.netscape == undefined ? manualConvertUTF8ToUnicode(u) : mozConvertUTF8ToUnicode(u);
}

function manualConvertUTF8ToUnicode(utf)
{
	var uni = utf;
	var src = 0;
	var dst = 0;
	var b1, b2, b3;
	var c;
	while(src < utf.length) {
		b1 = utf.charCodeAt(src++);
		if(b1 < 0x80) {
			dst++;
		} else if(b1 < 0xE0) {
			b2 = utf.charCodeAt(src++);
			c = String.fromCharCode(((b1 & 0x1F) << 6) | (b2 & 0x3F));
			uni = uni.substring(0,dst++).concat(c,utf.substr(src));
		} else {
			b2 = utf.charCodeAt(src++);
			b3 = utf.charCodeAt(src++);
			c = String.fromCharCode(((b1 & 0xF) << 12) | ((b2 & 0x3F) << 6) | (b3 & 0x3F));
			uni = uni.substring(0,dst++).concat(c,utf.substr(src));
		}
	}
	return uni;
}

function mozConvertUTF8ToUnicode(u)
{
	try {
		netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
		var converter = Components.classes["@mozilla.org/intl/scriptableunicodeconverter"].createInstance(Components.interfaces.nsIScriptableUnicodeConverter);
		converter.charset = "UTF-8";
	} catch(ex) {
		return manualConvertUTF8ToUnicode(u);
	} // fallback
	var s = converter.ConvertToUnicode(u);
	var fin = converter.Finish();
	return (fin.length > 0) ? s+fin : s;
}

function convertUnicodeToUTF8(s)
{
	if(window.netscape == undefined)
		return manualConvertUnicodeToUTF8(s);
	else
		return mozConvertUnicodeToUTF8(s);
}

function manualConvertUnicodeToUTF8(s)
{
	var re = /[^\u0000-\u007F]/g ;
	return s.replace(re,function($0) {return "&#" + $0.charCodeAt(0).toString() + ";";});
}

function mozConvertUnicodeToUTF8(s)
{
	try {
		netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
		var converter = Components.classes["@mozilla.org/intl/scriptableunicodeconverter"].createInstance(Components.interfaces.nsIScriptableUnicodeConverter);
		converter.charset = "UTF-8";
	} catch(ex) {
		return manualConvertUnicodeToUTF8(s);
	} // fallback
	var u = converter.ConvertFromUnicode(s);
	var fin = converter.Finish();
	return fin.length > 0 ? u + fin : u;
}

function convertUriToUTF8(uri,charSet)
{
	if(window.netscape == undefined || charSet == undefined || charSet == "")
		return uri;
	try {
		netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
		var converter = Components.classes["@mozilla.org/intl/utf8converterservice;1"].getService(Components.interfaces.nsIUTF8ConverterService);
	} catch(ex) {
		return uri;
	}
	return converter.convertURISpecToUTF8(uri,charSet);
}

function saveFile(fileUrl,content)
{
	var r = mozillaSaveFile(fileUrl,content);
	if(!r)
		r = ieSaveFile(fileUrl,content);
	if(!r)
		r = javaSaveFile(fileUrl,content);
	return r;
}

function loadFile(fileUrl)
{
	var r = mozillaLoadFile(fileUrl);
	if((r == null) || (r == false))
		r = ieLoadFile(fileUrl);
	if((r == null) || (r == false))
		r = javaLoadFile(fileUrl);
	return r;
}

function ieCreatePath(path)
{
	try {
		var fso = new ActiveXObject("Scripting.FileSystemObject");
	} catch(ex) {
		return null;
	}

	var pos = path.lastIndexOf("\\");
	if(pos!=-1)
		path = path.substring(0, pos+1);

	var scan = [];
	scan.push(path);
	var i = 0;
	do {
		var parent = fso.GetParentFolderName(scan[i++]);
		if (fso.FolderExists(parent))
			break;
		scan.push(parent);
	} while(true);

	for(i=scan.length-1;i>=0;i--) {
		if (!fso.FolderExists(scan[i]))
			fso.CreateFolder(scan[i]);
	}
	return true;
}

// Returns null if it can't do it, false if there's an error, true if it saved OK
function ieSaveFile(filePath,content)
{
	ieCreatePath(filePath);
	try {
		var fso = new ActiveXObject("Scripting.FileSystemObject");
	} catch(ex) {
		return null;
	}
	var file = fso.OpenTextFile(filePath,2,-1,0);
	file.Write(content);
	file.Close();
	return true;
}

// Returns null if it can't do it, false if there's an error, or a string of the content if successful
function ieLoadFile(filePath)
{
	try {
		var fso = new ActiveXObject("Scripting.FileSystemObject");
		var file = fso.OpenTextFile(filePath,1);
		var content = file.ReadAll();
		file.Close();
	} catch(ex) {
		return null;
	}
	return content;
}

function ieCopyFile(dest,source)
{
	ieCreatePath(dest);
	try {
		var fso = new ActiveXObject("Scripting.FileSystemObject");
		fso.GetFile(source).Copy(dest);
	} catch(ex) {
		return false;
	}
	return true;
}

// Returns null if it can't do it, false if there's an error, true if it saved OK
function mozillaSaveFile(filePath,content)
{
	if(window.Components) {
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			var file = Components.classes["@mozilla.org/file/local;1"].createInstance(Components.interfaces.nsILocalFile);
			file.initWithPath(filePath);
			if(!file.exists())
				file.create(0,0664);
			var out = Components.classes["@mozilla.org/network/file-output-stream;1"].createInstance(Components.interfaces.nsIFileOutputStream);
			out.init(file,0x20|0x02,00004,null);
			out.write(content,content.length);
			out.flush();
			out.close();
			return true;
		} catch(ex) {
			return false;
		}
	}
	return null;
}

// Returns null if it can't do it, false if there's an error, or a string of the content if successful
function mozillaLoadFile(filePath)
{
	if(window.Components) {
		try {
			netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			var file = Components.classes["@mozilla.org/file/local;1"].createInstance(Components.interfaces.nsILocalFile);
			file.initWithPath(filePath);
			if(!file.exists())
				return null;
			var inputStream = Components.classes["@mozilla.org/network/file-input-stream;1"].createInstance(Components.interfaces.nsIFileInputStream);
			inputStream.init(file,0x01,00004,null);
			var sInputStream = Components.classes["@mozilla.org/scriptableinputstream;1"].createInstance(Components.interfaces.nsIScriptableInputStream);
			sInputStream.init(inputStream);
			return sInputStream.read(sInputStream.available());
		} catch(ex) {
			return false;
		}
	}
	return null;
}

function javaUrlToFilename(url)
{
	var f = "//localhost";
	if(url.indexOf(f) == 0)
		return url.substring(f.length);
	var i = url.indexOf(":");
	if(i > 0)
		return url.substring(i-1);
	return url;
}

function javaSaveFile(filePath,content)
{
	try {
		if(document.applets["TiddlySaver"])
			return document.applets["TiddlySaver"].saveFile(javaUrlToFilename(filePath),"UTF-8",content);
	} catch(ex) {
	}
	try {
		var s = new java.io.PrintStream(new java.io.FileOutputStream(javaUrlToFilename(filePath)));
		s.print(content);
		s.close();
	} catch(ex) {
		return null;
	}
	return true;
}

function javaLoadFile(filePath)
{
	try {
		if(document.applets["TiddlySaver"])
			return String(document.applets["TiddlySaver"].loadFile(javaUrlToFilename(filePath),"UTF-8"));
	} catch(ex) {
	}
	var content = [];
	try {
		var r = new java.io.BufferedReader(new java.io.FileReader(javaUrlToFilename(filePath)));
		var line;
		while((line = r.readLine()) != null)
			content.push(new String(line));
		r.close();
	} catch(ex) {
		return null;
	}
	return content.join("\n");
}

//--
//-- Server adaptor for talking to static TiddlyWiki files
//--

function FileAdaptor()
{
	this.host = null;
	this.store = null;
	return this;
}

FileAdaptor.serverType = 'file';

FileAdaptor.prototype.setContext = function(context,userParams,callback)
{
	if(!context) context = {};
	context.userParams = userParams;
	if(callback) context.callback = callback;
	context.adaptor = this;
	if(!context.host)
		context.host = this.host;
	context.host = FileAdaptor.fullHostName(context.host);
	if(!context.workspace)
		context.workspace = this.workspace;
	return context;
};

FileAdaptor.fullHostName = function(host)
{
	if(!host)
		return '';
	if(!host.match(/:\/\//))
		host = 'http://' + host;
	return host;
};

FileAdaptor.minHostName = function(host)
{
	return host ? host.replace(/^http:\/\//,'').replace(/\/$/,'') : '';
};

// Open the specified host
FileAdaptor.prototype.openHost = function(host,context,userParams,callback)
{
	this.host = host;
	context = this.setContext(context,userParams,callback);
	context.status = true;
	if(callback)
		window.setTimeout(function() {callback(context,userParams);},10);
	return true;
};

FileAdaptor.loadTiddlyWikiCallback = function(status,context,responseText,url,xhr)
{
	context.status = status;
	if(!status) {
		context.statusText = "Error reading file: " + xhr.statusText;
	} else {
		context.adaptor.store = new TiddlyWiki();
		if(!context.adaptor.store.importTiddlyWiki(responseText))
			context.statusText = config.messages.invalidFileError.format([url]);
	}
	context.complete(context,context.userParams);
};

// Get the list of workspaces on a given server
FileAdaptor.prototype.getWorkspaceList = function(context,userParams,callback)
{
	context = this.setContext(context,userParams,callback);
	context.workspaces = [{title:"(default)"}];
	context.status = true;
	if(callback)
		window.setTimeout(function() {callback(context,userParams);},10);
	return true;
};

// Open the specified workspace
FileAdaptor.prototype.openWorkspace = function(workspace,context,userParams,callback)
{
	this.workspace = workspace;
	context = this.setContext(context,userParams,callback);
	context.status = true;
	if(callback)
		window.setTimeout(function() {callback(context,userParams);},10);
	return true;
};

// Gets the list of tiddlers within a given workspace
FileAdaptor.prototype.getTiddlerList = function(context,userParams,callback,filter)
{
	context = this.setContext(context,userParams,callback);
	if(!context.filter)
		context.filter = filter;
	context.complete = FileAdaptor.getTiddlerListComplete;
	if(this.store) {
		var ret = context.complete(context,context.userParams);
	} else {
		ret = loadRemoteFile(context.host,FileAdaptor.loadTiddlyWikiCallback,context);
		if(typeof ret != "string")
			ret = true;
	}
	return ret;
};

FileAdaptor.getTiddlerListComplete = function(context,userParams)
{
	if(context.filter) {
		context.tiddlers = context.adaptor.store.filterTiddlers(context.filter);
	} else {
		context.tiddlers = [];
		context.adaptor.store.forEachTiddler(function(title,tiddler) {context.tiddlers.push(tiddler);});
	}
	for(var i=0; i<context.tiddlers.length; i++) {
		context.tiddlers[i].fields['server.type'] = FileAdaptor.serverType;
		context.tiddlers[i].fields['server.host'] = FileAdaptor.minHostName(context.host);
		context.tiddlers[i].fields['server.page.revision'] = context.tiddlers[i].modified.convertToYYYYMMDDHHMM();
	}
	context.status = true;
	if(context.callback) {
		window.setTimeout(function() {context.callback(context,userParams);},10);
	}
	return true;
};

FileAdaptor.prototype.generateTiddlerInfo = function(tiddler)
{
	var info = {};
	info.uri = tiddler.fields['server.host'] + "#" + tiddler.title;
	return info;
};

// Retrieve a tiddler from a given workspace on a given server
FileAdaptor.prototype.getTiddler = function(title,context,userParams,callback)
{
	context = this.setContext(context,userParams,callback);
	context.title = title;
	context.complete = FileAdaptor.getTiddlerComplete;
	return context.adaptor.store ? 
		context.complete(context,context.userParams) :
		loadRemoteFile(context.host,FileAdaptor.loadTiddlyWikiCallback,context);
};

FileAdaptor.getTiddlerComplete = function(context,userParams)
{
	var t = context.adaptor.store.fetchTiddler(context.title);
	t.fields['server.type'] = FileAdaptor.serverType;
	t.fields['server.host'] = FileAdaptor.minHostName(context.host);
	t.fields['server.page.revision'] = t.modified.convertToYYYYMMDDHHMM();
	context.tiddler = t;
	context.status = true;
	if(context.allowSynchronous) {
		context.isSynchronous = true;
		context.callback(context,userParams);
	} else {
		window.setTimeout(function() {callback(context,userParams);},10);
	}
	return true;
};

FileAdaptor.prototype.close = function()
{
	delete this.store;
	this.store = null;
};

config.adaptors[FileAdaptor.serverType] = FileAdaptor;

//--
//-- Remote HTTP requests
//--

function loadRemoteFile(url,callback,params)
{
	return doHttp("GET",url,null,null,null,null,callback,params,null);
}

// HTTP status codes
var httpStatus = {
	OK: 200,
	ContentCreated: 201,
	NoContent: 204,
	MultiStatus: 207,
	Unauthorized: 401,
	Forbidden: 403,
	NotFound: 404,
	MethodNotAllowed: 405
};

function doHttp(type,url,data,contentType,username,password,callback,params,headers)
{
	var x = getXMLHttpRequest();
	if(!x)
		return "Can't create XMLHttpRequest object";
	x.onreadystatechange = function() {
		try {
			var status = x.status;
		} catch(ex) {
			status = false;
		}
		if (x.readyState == 4 && callback && (status !== undefined)) {
			if([0, httpStatus.OK, httpStatus.ContentCreated, httpStatus.NoContent, httpStatus.MultiStatus].contains(status))
				callback(true,params,x.responseText,url,x);
			else
				callback(false,params,null,url,x);
			x.onreadystatechange = function(){};
			x = null;
		}
	};
	if(window.Components && window.netscape && window.netscape.security && document.location.protocol.indexOf("http") == -1) {
		window.netscape.security.PrivilegeManager.enablePrivilege("UniversalBrowserRead");
	}
	try {
		url = url + (url.indexOf("?") < 0 ? "?" : "&") + "nocache=" + Math.random();
		x.open(type,url,true,username,password);
		if(data) {
			x.setRequestHeader("Content-Type", contentType ? contentType : "application/x-www-form-urlencoded");
		}
		if(x.overrideMimeType){
			x.setRequestHeader("Connection", "close");
		}
		if(headers) {
			for(var n in headers){
				x.setRequestHeader(n,headers[n]);
			}
		}
		x.setRequestHeader("X-Requested-With", "TiddlyWiki " + version.major + "." + version.minor + "." + version.revision + (version.beta ? " (beta " + version.beta + ")" : ""));
		x.send(data);
	} catch(ex) {
		return exceptionText(ex);
	}
	return x;
}

function getXMLHttpRequest()
{
	try {
		var x = new XMLHttpRequest(); // Modern
	} catch(ex) {
		try {
			x = new ActiveXObject("Msxml2.XMLHTTP"); // IE 6
		} catch (ex2) {
			return null;
		}
	}
	return x;
}

//--
//-- TiddlyWiki-specific utility functions
//--

function createTiddlyButton(parent,text,tooltip,action,className,id,accessKey,attribs)
{
	var btn = document.createElement("a");
	if(action) {
		btn.onclick = action;
		btn.setAttribute("href","javascript:;");
	}
	if(tooltip)
		btn.setAttribute("title",tooltip);
	if(text)
		btn.appendChild(document.createTextNode(text));
	btn.className = className ? className : "button";
	if(id)
		btn.id = id;
	if(attribs) {
		for(var n in attribs) {
			btn.setAttribute(n,attribs[n]);
		}
	}
	if(parent)
		parent.appendChild(btn);
	if(accessKey)
		btn.setAttribute("accessKey",accessKey);
	return btn;
}

function createTiddlyLink(place,title,includeText,className,isStatic,linkedFromTiddler,noToggle)
{
	var text = includeText ? title : null;
	var i = getTiddlyLinkInfo(title,className);
	var btn = isStatic ? createExternalLink(place,store.getTiddlerText("SiteUrl",null) + "#" + title) : createTiddlyButton(place,text,i.subTitle,onClickTiddlerLink,i.classes);
	btn.setAttribute("refresh","link");
	btn.setAttribute("tiddlyLink",title);
	if(noToggle)
		btn.setAttribute("noToggle","true");
	if(linkedFromTiddler) {
		var fields = linkedFromTiddler.getInheritedFields();
		if(fields)
			btn.setAttribute("tiddlyFields",fields);
	}
	return btn;
}

function refreshTiddlyLink(e,title)
{
	var i = getTiddlyLinkInfo(title,e.className);
	e.className = i.classes;
	e.title = i.subTitle;
}

function getTiddlyLinkInfo(title,currClasses)
{
	var classes = currClasses ? currClasses.split(" ") : [];
	classes.pushUnique("tiddlyLink");
	var tiddler = store.fetchTiddler(title);
	var subTitle;
	if(tiddler) {
		subTitle = tiddler.getSubtitle();
		classes.pushUnique("tiddlyLinkExisting");
		classes.remove("tiddlyLinkNonExisting");
		classes.remove("shadow");
	} else {
		classes.remove("tiddlyLinkExisting");
		classes.pushUnique("tiddlyLinkNonExisting");
		if(store.isShadowTiddler(title)) {
			subTitle = config.messages.shadowedTiddlerToolTip.format([title]);
			classes.pushUnique("shadow");
		} else {
			subTitle = config.messages.undefinedTiddlerToolTip.format([title]);
			classes.remove("shadow");
		}
	}
	if(typeof config.annotations[title]=="string")
		subTitle = config.annotations[title];
	return {classes: classes.join(" "),subTitle: subTitle};
}

function createExternalLink(place,url)
{
	var link = document.createElement("a");
	link.className = "externalLink";
	link.href = url;
	link.title = config.messages.externalLinkTooltip.format([url]);
	if(config.options.chkOpenInNewWindow)
		link.target = "_blank";
	place.appendChild(link);
	return link;
}

// Event handler for clicking on a tiddly link
function onClickTiddlerLink(ev)
{
	var e = ev ? ev : window.event;
	var target = resolveTarget(e);
	var link = target;
	var title = null;
	var fields = null;
	var noToggle = null;
	do {
		title = link.getAttribute("tiddlyLink");
		fields = link.getAttribute("tiddlyFields");
		noToggle = link.getAttribute("noToggle");
		link = link.parentNode;
	} while(title == null && link != null);
	if(!store.isShadowTiddler(title)) {
		var f = fields ? fields.decodeHashMap() : {};
		fields = String.encodeHashMap(merge(f,config.defaultCustomFields,true));
	}
	if(title) {
		var toggling = e.metaKey || e.ctrlKey;
		if(config.options.chkToggleLinks)
			toggling = !toggling;
		if(noToggle)
			toggling = false;
		if(store.getTiddler(title))
			fields = null;
		story.displayTiddler(target,title,null,true,null,fields,toggling);
	}
	clearMessage();
	return false;
}

// Create a button for a tag with a popup listing all the tiddlers that it tags
function createTagButton(place,tag,excludeTiddler)
{
	var btn = createTiddlyButton(place,tag,config.views.wikified.tag.tooltip.format([tag]),onClickTag);
	btn.setAttribute("tag",tag);
	if(excludeTiddler)
		btn.setAttribute("tiddler",excludeTiddler);
	return btn;
}

// Event handler for clicking on a tiddler tag
function onClickTag(ev)
{
	var e = ev ? ev : window.event;
	var popup = Popup.create(this);
	var tag = this.getAttribute("tag");
	var title = this.getAttribute("tiddler");
	if(popup && tag) {
		var tagged = store.getTaggedTiddlers(tag);
		var titles = [];
		var li,r;
		for(r=0;r<tagged.length;r++) {
			if(tagged[r].title != title)
				titles.push(tagged[r].title);
		}
		var lingo = config.views.wikified.tag;
		if(titles.length > 0) {
			var openAll = createTiddlyButton(createTiddlyElement(popup,"li"),lingo.openAllText.format([tag]),lingo.openAllTooltip,onClickTagOpenAll);
			openAll.setAttribute("tag",tag);
			createTiddlyElement(createTiddlyElement(popup,"li",null,"listBreak"),"div");
			for(r=0; r<titles.length; r++) {
				createTiddlyLink(createTiddlyElement(popup,"li"),titles[r],true);
			}
		} else {
			createTiddlyText(createTiddlyElement(popup,"li",null,"disabled"),lingo.popupNone.format([tag]));
		}
		createTiddlyElement(createTiddlyElement(popup,"li",null,"listBreak"),"div");
		var h = createTiddlyLink(createTiddlyElement(popup,"li"),tag,false);
		createTiddlyText(h,lingo.openTag.format([tag]));
	}
	Popup.show();
	e.cancelBubble = true;
	if(e.stopPropagation) e.stopPropagation();
	return false;
}

// Event handler for 'open all' on a tiddler popup
function onClickTagOpenAll(ev)
{
	var e = ev ? ev : window.event;
	var tag = this.getAttribute("tag");
	var tagged = store.getTaggedTiddlers(tag);
	story.displayTiddlers(this,tagged);
	return false;
}

function onClickError(ev)
{
	var e = ev ? ev : window.event;
	var popup = Popup.create(this);
	var lines = this.getAttribute("errorText").split("\n");
	for(var t=0; t<lines.length; t++)
		createTiddlyElement(popup,"li",null,null,lines[t]);
	Popup.show();
	e.cancelBubble = true;
	if(e.stopPropagation) e.stopPropagation();
	return false;
}

function createTiddlyDropDown(place,onchange,options,defaultValue)
{
	var sel = createTiddlyElement(place,"select");
	sel.onchange = onchange;
	for(var t=0; t<options.length; t++) {
		var e = createTiddlyElement(sel,"option",null,null,options[t].caption);
		e.value = options[t].name;
		if(options[t].name == defaultValue)
			e.selected = true;
	}
	return sel;
}

function createTiddlyPopup(place,caption,tooltip,tiddler)
{
	if(tiddler.text) {
		createTiddlyLink(place,caption,true);
		var btn = createTiddlyButton(place,glyph("downArrow"),tooltip,onClickTiddlyPopup,"tiddlerPopupButton");
		btn.tiddler = tiddler;
	} else {
		createTiddlyText(place,caption);
	}
}

function onClickTiddlyPopup(ev)
{
	var e = ev ? ev : window.event;
	var tiddler = this.tiddler;
	if(tiddler.text) {
		var popup = Popup.create(this,"div","popupTiddler");
		wikify(tiddler.text,popup,null,tiddler);
		Popup.show();
	}
	if(e) e.cancelBubble = true;
	if(e && e.stopPropagation) e.stopPropagation();
	return false;
}

function createTiddlyError(place,title,text)
{
	var btn = createTiddlyButton(place,title,null,onClickError,"errorButton");
	if(text) btn.setAttribute("errorText",text);
}

function merge(dst,src,preserveExisting)
{
	for(p in src) {
		if(!preserveExisting || dst[p] === undefined)
			dst[p] = src[p];
	}
	return dst;
}

// Returns a string containing the description of an exception, optionally prepended by a message
function exceptionText(e,message)
{
	var s = e.description ? e.description : e.toString();
	return message ? "%0:\n%1".format([message,s]) : s;
}

// Displays an alert of an exception description with optional message
function showException(e,message)
{
	alert(exceptionText(e,message));
}

function alertAndThrow(m)
{
	alert(m);
	throw(m);
}

function glyph(name)
{
	var g = config.glyphs;
	var b = g.currBrowser;
	if(b == null) {
		b = 0;
		while(!g.browsers[b]() && b < g.browsers.length-1)
			b++;
		g.currBrowser = b;
	}
	if(!g.codes[name])
		return "";
	return g.codes[name][b];
}


//-
//- Animation engine
//-

function Animator()
{
	this.running = 0; // Incremented at start of each animation, decremented afterwards. If zero, the interval timer is disabled
	this.timerID = 0; // ID of the timer used for animating
	this.animations = []; // List of animations in progress
	return this;
}

// Start animation engine
Animator.prototype.startAnimating = function() //# Variable number of arguments
{
	for(var t=0; t<arguments.length; t++)
		this.animations.push(arguments[t]);
	if(this.running == 0) {
		var me = this;
		this.timerID = window.setInterval(function() {me.doAnimate(me);},10);
	}
	this.running += arguments.length;
};

// Perform an animation engine tick, calling each of the known animation modules
Animator.prototype.doAnimate = function(me)
{
	var a = 0;
	while(a < me.animations.length) {
		var animation = me.animations[a];
		if(animation.tick()) {
			a++;
		} else {
			me.animations.splice(a,1);
			if(--me.running == 0)
				window.clearInterval(me.timerID);
		}
	}
};

Animator.slowInSlowOut = function(progress)
{
	return(1-((Math.cos(progress * Math.PI)+1)/2));
};

//--
//-- Morpher animation
//--

// Animate a set of properties of an element
function Morpher(element,duration,properties,callback)
{
	this.element = element;
	this.duration = duration;
	this.properties = properties;
	this.startTime = new Date();
	this.endTime = Number(this.startTime) + duration;
	this.callback = callback;
	this.tick();
	return this;
}

Morpher.prototype.assignStyle = function(element,style,value)
{
	switch(style) {
		case "-tw-vertScroll":
			window.scrollTo(findScrollX(),value);
			break;
		case "-tw-horizScroll":
			window.scrollTo(value,findScrollY());
			break;
		default:
			element.style[style] = value;
			break;
	}
};

Morpher.prototype.stop = function()
{
	for(var t=0; t<this.properties.length; t++) {
		var p = this.properties[t];
		if(p.atEnd !== undefined) {
			this.assignStyle(this.element,p.style,p.atEnd);
		}
	}
	if(this.callback)
		this.callback(this.element,this.properties);
};

Morpher.prototype.tick = function()
{
	var currTime = Number(new Date());
	progress = Animator.slowInSlowOut(Math.min(1,(currTime-this.startTime)/this.duration));
	for(var t=0; t<this.properties.length; t++) {
		var p = this.properties[t];
		if(p.start !== undefined && p.end !== undefined) {
			var template = p.template ? p.template : "%0";
			switch(p.format) {
				case undefined:
				case "style":
					var v = p.start + (p.end-p.start) * progress;
					this.assignStyle(this.element,p.style,template.format([v]));
					break;
				case "color":
					break;
			}
		}
	}
	if(currTime >= this.endTime) {
		this.stop();
		return false;
	}
	return true;
};

//--
//-- Zoomer animation
//--

function Zoomer(text,startElement,targetElement,unused)
{
	var e = createTiddlyElement(document.body,"div",null,"zoomer");
	createTiddlyElement(e,"div",null,null,text);
	var winWidth = findWindowWidth();
	var winHeight = findWindowHeight();
	var p = [
		{style: 'left', start: findPosX(startElement), end: findPosX(targetElement), template: '%0px'},
		{style: 'top', start: findPosY(startElement), end: findPosY(targetElement), template: '%0px'},
		{style: 'width', start: Math.min(startElement.scrollWidth,winWidth), end: Math.min(targetElement.scrollWidth,winWidth), template: '%0px', atEnd: 'auto'},
		{style: 'height', start: Math.min(startElement.scrollHeight,winHeight), end: Math.min(targetElement.scrollHeight,winHeight), template: '%0px', atEnd: 'auto'},
		{style: 'fontSize', start: 8, end: 24, template: '%0pt'}
	];
	var c = function(element,properties) {removeNode(element);};
	return new Morpher(e,config.animDuration,p,c);
}

//--
//-- Scroller animation
//--

function Scroller(targetElement,unused)
{
	var p = [
		{style: '-tw-vertScroll', start: findScrollY(), end: ensureVisible(targetElement)}
	];
	return new Morpher(targetElement,config.animDuration,p);
}

//--
//-- Slider animation
//--

// deleteMode - "none", "all" [delete target element and it's children], [only] "children" [but not the target element]
function Slider(element,opening,unused,deleteMode)
{
	element.style.overflow = 'hidden';
	if(opening)
		element.style.height = '0px'; // Resolves a Firefox flashing bug
	element.style.display = 'block';
	var left = findPosX(element);
	var width = element.scrollWidth;
	var height = element.scrollHeight;
	var winWidth = findWindowWidth();
	var p = [];
	var c = null;
	if(opening) {
		p.push({style: 'height', start: 0, end: height, template: '%0px', atEnd: 'auto'});
		p.push({style: 'opacity', start: 0, end: 1, template: '%0'});
		p.push({style: 'filter', start: 0, end: 100, template: 'alpha(opacity:%0)'});
	} else {
		p.push({style: 'height', start: height, end: 0, template: '%0px'});
		p.push({style: 'display', atEnd: 'none'});
		p.push({style: 'opacity', start: 1, end: 0, template: '%0'});
		p.push({style: 'filter', start: 100, end: 0, template: 'alpha(opacity:%0)'});
		switch(deleteMode) {
			case "all":
				c = function(element,properties) {removeNode(element);};
				break;
			case "children":
				c = function(element,properties) {removeChildren(element);};
				break;
		}
	}
	return new Morpher(element,config.animDuration,p,c);
}

//--
//-- Popup menu
//--

var Popup = {
	stack: [] // Array of objects with members root: and popup:
	};

Popup.create = function(root,elem,theClass)
{
	Popup.remove();
	var popup = createTiddlyElement(document.body,elem ? elem : "ol","popup",theClass ? theClass : "popup");
	Popup.stack.push({root: root, popup: popup});
	return popup;
};

Popup.onDocumentClick = function(ev)
{
	var e = ev ? ev : window.event;
	if(e.eventPhase == undefined)
		Popup.remove();
	else if(e.eventPhase == Event.BUBBLING_PHASE || e.eventPhase == Event.AT_TARGET)
		Popup.remove();
	return true;
};

Popup.show = function(unused1,unused2)
{
	var curr = Popup.stack[Popup.stack.length-1];
	this.place(curr.root,curr.popup);
	addClass(curr.root,"highlight");
	if(config.options.chkAnimate && anim && typeof Scroller == "function")
		anim.startAnimating(new Scroller(curr.popup));
	else
		window.scrollTo(0,ensureVisible(curr.popup));
};

Popup.place = function(root,popup,offset)
{
	if(!offset) var offset = {x:0, y:0};
	var rootLeft = findPosX(root);
	var rootTop = findPosY(root);
	var rootHeight = root.offsetHeight;
	var popupLeft = rootLeft + offset.x;
	var popupTop = rootTop + rootHeight + offset.y;
	var winWidth = findWindowWidth();
	if(popup.offsetWidth > winWidth*0.75)
		popup.style.width = winWidth*0.75 + "px";
	var popupWidth = popup.offsetWidth;
	if(popupLeft + popupWidth > winWidth)
		popupLeft = winWidth - popupWidth;
	popup.style.left = popupLeft + "px";
	popup.style.top = popupTop + "px";
	popup.style.display = "block";
};

Popup.remove = function()
{
	if(Popup.stack.length > 0) {
		Popup.removeFrom(0);
	}
};

Popup.removeFrom = function(from)
{
	for(var t=Popup.stack.length-1; t>=from; t--) {
		var p = Popup.stack[t];
		removeClass(p.root,"highlight");
		removeNode(p.popup);
	}
	Popup.stack = Popup.stack.slice(0,from);
};

//--
//-- Wizard support
//--

function Wizard(elem)
{
	if(elem) {
		this.formElem = findRelated(elem,"wizard","className");
		this.bodyElem = findRelated(this.formElem.firstChild,"wizardBody","className","nextSibling");
		this.footElem = findRelated(this.formElem.firstChild,"wizardFooter","className","nextSibling");
	} else {
		this.formElem = null;
		this.bodyElem = null;
		this.footElem = null;
	}
}

Wizard.prototype.setValue = function(name,value)
{
	if(this.formElem)
		this.formElem[name] = value;
};

Wizard.prototype.getValue = function(name)
{
	return this.formElem ? this.formElem[name] : null;
};

Wizard.prototype.createWizard = function(place,title)
{
	this.formElem = createTiddlyElement(place,"form",null,"wizard");
	createTiddlyElement(this.formElem,"h1",null,null,title);
	this.bodyElem = createTiddlyElement(this.formElem,"div",null,"wizardBody");
	this.footElem = createTiddlyElement(this.formElem,"div",null,"wizardFooter");
};

Wizard.prototype.clear = function()
{
	removeChildren(this.bodyElem);
};

Wizard.prototype.setButtons = function(buttonInfo,status)
{
	removeChildren(this.footElem);
	for(var t=0; t<buttonInfo.length; t++) {
		createTiddlyButton(this.footElem,buttonInfo[t].caption,buttonInfo[t].tooltip,buttonInfo[t].onClick);
		insertSpacer(this.footElem);
		}
	if(typeof status == "string") {
		createTiddlyElement(this.footElem,"span",null,"status",status);
	}
};

Wizard.prototype.addStep = function(stepTitle,html)
{
	removeChildren(this.bodyElem);
	var w = createTiddlyElement(this.bodyElem,"div");
	createTiddlyElement(w,"h2",null,null,stepTitle);
	var step = createTiddlyElement(w,"div",null,"wizardStep");
	step.innerHTML = html;
	applyHtmlMacros(step,tiddler);
};

Wizard.prototype.getElement = function(name)
{
	return this.formElem.elements[name];
};

Wizard.prototype.getForm = function()
{
	return this.formElem;
};


//--
//-- ListView gadget
//--

var ListView = {};

// Create a listview
ListView.create = function(place,listObject,listTemplate,callback,className)
{
	var table = createTiddlyElement(place,"table",null,className ? className : "listView twtable");
	var thead = createTiddlyElement(table,"thead");
	var r = createTiddlyElement(thead,"tr");
	for(var t=0; t<listTemplate.columns.length; t++) {
		var columnTemplate = listTemplate.columns[t];
		var c = createTiddlyElement(r,"th");
		var colType = ListView.columnTypes[columnTemplate.type];
		if(colType && colType.createHeader)
			colType.createHeader(c,columnTemplate,t);
	}
	var tbody = createTiddlyElement(table,"tbody");
	for(var rc=0; rc<listObject.length; rc++) {
		rowObject = listObject[rc];
		r = createTiddlyElement(tbody,"tr");
		for(c=0; c<listTemplate.rowClasses.length; c++) {
			if(rowObject[listTemplate.rowClasses[c].field])
				addClass(r,listTemplate.rowClasses[c].className);
		}
		rowObject.rowElement = r;
		rowObject.colElements = {};
		for(var cc=0; cc<listTemplate.columns.length; cc++) {
			c = createTiddlyElement(r,"td");
			columnTemplate = listTemplate.columns[cc];
			var field = columnTemplate.field;
			colType = ListView.columnTypes[columnTemplate.type];
			if(colType && colType.createItem)
				colType.createItem(c,rowObject,field,columnTemplate,cc,rc);
			rowObject.colElements[field] = c;
		}
	}
	if(callback && listTemplate.actions)
		createTiddlyDropDown(place,ListView.getCommandHandler(callback),listTemplate.actions);
	if(callback && listTemplate.buttons) {
		for(t=0; t<listTemplate.buttons.length; t++) {
			var a = listTemplate.buttons[t];
			if(a && a.name != "")
				createTiddlyButton(place,a.caption,null,ListView.getCommandHandler(callback,a.name,a.allowEmptySelection));
		}
	}
	return table;
};

ListView.getCommandHandler = function(callback,name,allowEmptySelection)
{
	return function(e) {
		var view = findRelated(this,"TABLE",null,"previousSibling");
		var tiddlers = [];
		ListView.forEachSelector(view,function(e,rowName) {
					if(e.checked)
						tiddlers.push(rowName);
					});
		if(tiddlers.length == 0 && !allowEmptySelection) {
			alert(config.messages.nothingSelected);
		} else {
			if(this.nodeName.toLowerCase() == "select") {
				callback(view,this.value,tiddlers);
				this.selectedIndex = 0;
			} else {
				callback(view,name,tiddlers);
			}
		}
	};
};

// Invoke a callback for each selector checkbox in the listview
ListView.forEachSelector = function(view,callback)
{
	var checkboxes = view.getElementsByTagName("input");
	var hadOne = false;
	for(var t=0; t<checkboxes.length; t++) {
		var cb = checkboxes[t];
		if(cb.getAttribute("type") == "checkbox") {
			var rn = cb.getAttribute("rowName");
			if(rn) {
				callback(cb,rn);
				hadOne = true;
			}
		}
	}
	return hadOne;
};

ListView.getSelectedRows = function(view)
{
	var rowNames = [];
	ListView.forEachSelector(view,function(e,rowName) {
				if(e.checked)
					rowNames.push(rowName);
				});
	return rowNames;
};

ListView.columnTypes = {};

ListView.columnTypes.String = {
	createHeader: function(place,columnTemplate,col)
		{
			createTiddlyText(place,columnTemplate.title);
		},
	createItem: function(place,listObject,field,columnTemplate,col,row)
		{
			var v = listObject[field];
			if(v != undefined)
				createTiddlyText(place,v);
		}
};

ListView.columnTypes.WikiText = {
	createHeader: ListView.columnTypes.String.createHeader,
	createItem: function(place,listObject,field,columnTemplate,col,row)
		{
			var v = listObject[field];
			if(v != undefined)
				wikify(v,place,null,null);
		}
};

ListView.columnTypes.Tiddler = {
	createHeader: ListView.columnTypes.String.createHeader,
	createItem: function(place,listObject,field,columnTemplate,col,row)
		{
			var v = listObject[field];
			if(v != undefined && v.title)
				createTiddlyPopup(place,v.title,config.messages.listView.tiddlerTooltip,v);
		}
};

ListView.columnTypes.Size = {
	createHeader: ListView.columnTypes.String.createHeader,
	createItem: function(place,listObject,field,columnTemplate,col,row)
		{
			var v = listObject[field];
			if(v != undefined) {
				var t = 0;
				while(t<config.messages.sizeTemplates.length-1 && v<config.messages.sizeTemplates[t].unit)
					t++;
				createTiddlyText(place,config.messages.sizeTemplates[t].template.format([Math.round(v/config.messages.sizeTemplates[t].unit)]));
			}
		}
};

ListView.columnTypes.Link = {
	createHeader: ListView.columnTypes.String.createHeader,
	createItem: function(place,listObject,field,columnTemplate,col,row)
		{
			var v = listObject[field];
			var c = columnTemplate.text;
			if(v != undefined)
				createTiddlyText(createExternalLink(place,v),c ? c : v);
		}
};

ListView.columnTypes.Date = {
	createHeader: ListView.columnTypes.String.createHeader,
	createItem: function(place,listObject,field,columnTemplate,col,row)
		{
			var v = listObject[field];
			if(v != undefined)
				createTiddlyText(place,v.formatString(columnTemplate.dateFormat));
		}
};

ListView.columnTypes.StringList = {
	createHeader: ListView.columnTypes.String.createHeader,
	createItem: function(place,listObject,field,columnTemplate,col,row)
		{
			var v = listObject[field];
			if(v != undefined) {
				for(var t=0; t<v.length; t++) {
					createTiddlyText(place,v[t]);
					createTiddlyElement(place,"br");
				}
			}
		}
};

ListView.columnTypes.Selector = {
	createHeader: function(place,columnTemplate,col)
		{
			createTiddlyCheckbox(place,null,false,this.onHeaderChange);
		},
	createItem: function(place,listObject,field,columnTemplate,col,row)
		{
			var e = createTiddlyCheckbox(place,null,listObject[field],null);
			e.setAttribute("rowName",listObject[columnTemplate.rowName]);
		},
	onHeaderChange: function(e)
		{
			var state = this.checked;
			var view = findRelated(this,"TABLE");
			if(!view)
				return;
			ListView.forEachSelector(view,function(e,rowName) {
								e.checked = state;
							});
		}
};

ListView.columnTypes.Tags = {
	createHeader: ListView.columnTypes.String.createHeader,
	createItem: function(place,listObject,field,columnTemplate,col,row)
		{
			var tags = listObject[field];
			createTiddlyText(place,String.encodeTiddlyLinkList(tags));
		}
};

ListView.columnTypes.Boolean = {
	createHeader: ListView.columnTypes.String.createHeader,
	createItem: function(place,listObject,field,columnTemplate,col,row)
		{
			if(listObject[field] == true)
				createTiddlyText(place,columnTemplate.trueText);
			if(listObject[field] == false)
				createTiddlyText(place,columnTemplate.falseText);
		}
};

ListView.columnTypes.TagCheckbox = {
	createHeader: ListView.columnTypes.String.createHeader,
	createItem: function(place,listObject,field,columnTemplate,col,row)
		{
			var e = createTiddlyCheckbox(place,null,listObject[field],this.onChange);
			e.setAttribute("tiddler",listObject.title);
			e.setAttribute("tag",columnTemplate.tag);
		},
	onChange : function(e)
		{
			var tag = this.getAttribute("tag");
			var tiddler = this.getAttribute("tiddler");
			store.setTiddlerTag(tiddler,this.checked,tag);
		}
};

ListView.columnTypes.TiddlerLink = {
	createHeader: ListView.columnTypes.String.createHeader,
	createItem: function(place,listObject,field,columnTemplate,col,row)
		{
			var v = listObject[field];
			if(v != undefined) {
				var link = createTiddlyLink(place,listObject[columnTemplate.tiddlerLink],false,null);
				createTiddlyText(link,listObject[field]);
			}
		}
};

//--
//-- Augmented methods for the JavaScript Number(), Array(), String() and Date() objects
//--

// Clamp a number to a range
Number.prototype.clamp = function(min,max)
{
	var c = this;
	if(c < min)
		c = min;
	if(c > max)
		c = max;
	return c;
};

// Add indexOf function if browser does not support it
if(!Array.indexOf) {
Array.prototype.indexOf = function(item,from)
{
	if(!from)
		from = 0;
	for(var i=from; i<this.length; i++) {
		if(this[i] === item)
			return i;
	}
	return -1;
};}

// Find an entry in a given field of the members of an array
Array.prototype.findByField = function(field,value)
{
	for(var t=0; t<this.length; t++) {
		if(this[t][field] == value)
			return t;
	}
	return null;
};

// Return whether an entry exists in an array
Array.prototype.contains = function(item)
{
	return this.indexOf(item) != -1;
};

// Adds, removes or toggles a particular value within an array
//  value - value to add
//  mode - +1 to add value, -1 to remove value, 0 to toggle it
Array.prototype.setItem = function(value,mode)
{
	var p = this.indexOf(value);
	if(mode == 0)
		mode = (p == -1) ? +1 : -1;
	if(mode == +1) {
		if(p == -1)
			this.push(value);
	} else if(mode == -1) {
		if(p != -1)
			this.splice(p,1);
	}
};

// Return whether one of a list of values exists in an array
Array.prototype.containsAny = function(items)
{
	for(var i=0; i<items.length; i++) {
		if (this.indexOf(items[i]) != -1)
			return true;
	}
	return false;
};

// Return whether all of a list of values exists in an array
Array.prototype.containsAll = function(items)
{
	for (var i = 0; i<items.length; i++) {
		if (this.indexOf(items[i]) == -1)
			return false;
	}
	return true;
};

// Push a new value into an array only if it is not already present in the array. If the optional unique parameter is false, it reverts to a normal push
Array.prototype.pushUnique = function(item,unique)
{
	if(unique === false) {
		this.push(item);
	} else {
		if(this.indexOf(item) == -1)
			this.push(item);
	}
};

Array.prototype.remove = function(item)
{
	var p = this.indexOf(item);
	if(p != -1)
		this.splice(p,1);
};

if(!Array.prototype.map){
Array.prototype.map = function(fn, thisObj) {
    var scope = thisObj || window;
    var a = [];
    for ( var i=0, j=this.length; i < j; ++i ) {
        a.push(fn.call(scope, this[i], i, this));
    }
    return a;
};}// Get characters from the right end of a string
String.prototype.right = function(n)
{
	return n < this.length ? this.slice(this.length-n) : this;
};

// Trim whitespace from both ends of a string
String.prototype.trim = function()
{
	return this.replace(/^\s*|\s*$/g,"");
};

// Convert a string from a CSS style property name to a JavaScript style name ("background-color" -> "backgroundColor")
String.prototype.unDash = function()
{
	var s = this.split("-");
	if(s.length > 1) {
		for(var t=1; t<s.length; t++)
			s[t] = s[t].substr(0,1).toUpperCase() + s[t].substr(1);
	}
	return s.join("");
};

// Substitute substrings from an array into a format string that includes '%1'-type specifiers
String.prototype.format = function(substrings)
{
	var subRegExp = /(?:%(\d+))/mg;
	var currPos = 0;
	var r = [];
	do {
		var match = subRegExp.exec(this);
		if(match && match[1]) {
			if(match.index > currPos)
				r.push(this.substring(currPos,match.index));
			r.push(substrings[parseInt(match[1])]);
			currPos = subRegExp.lastIndex;
		}
	} while(match);
	if(currPos < this.length)
		r.push(this.substring(currPos,this.length));
	return r.join("");
};

// Escape any special RegExp characters with that character preceded by a backslash
String.prototype.escapeRegExp = function()
{
	var s = "\\^$*+?()=!|,{}[].";
	var c = this;
	for(var t=0; t<s.length; t++)
		c = c.replace(new RegExp("\\" + s.substr(t,1),"g"),"\\" + s.substr(t,1));
	return c;
};

// Convert "\" to "\s", newlines to "\n" (and remove carriage returns)
String.prototype.escapeLineBreaks = function()
{
	return this.replace(/\\/mg,"\\s").replace(/\n/mg,"\\n").replace(/\r/mg,"");
};

// Convert "\n" to newlines, "\b" to " ", "\s" to "\" (and remove carriage returns)
String.prototype.unescapeLineBreaks = function()
{
	return this.replace(/\\n/mg,"\n").replace(/\\b/mg," ").replace(/\\s/mg,"\\").replace(/\r/mg,"");
};

// Convert & to "&amp;", < to "&lt;", > to "&gt;" and " to "&quot;"
String.prototype.htmlEncode = function()
{
	return this.replace(/&/mg,"&amp;").replace(/</mg,"&lt;").replace(/>/mg,"&gt;").replace(/\"/mg,"&quot;");
};

// Convert "&amp;" to &, "&lt;" to <, "&gt;" to > and "&quot;" to "
String.prototype.htmlDecode = function()
{
	return this.replace(/&lt;/mg,"<").replace(/&gt;/mg,">").replace(/&quot;/mg,"\"").replace(/&amp;/mg,"&");
};

// Convert a string to it's JSON representation by encoding control characters, double quotes and backslash. See json.org
String.prototype.toJSONString = function()
{
	var m = {
		'\b': '\\b',
		'\f': '\\f',
		'\n': '\\n',
		'\r': '\\r',
		'\t': '\\t',
		'"' : '\\"',
		'\\': '\\\\'
		};
	var replaceFn = function(a,b) {
		var c = m[b];
		if(c)
			return c;
		c = b.charCodeAt();
		return '\\u00' + Math.floor(c / 16).toString(16) + (c % 16).toString(16);
		};
	if(/["\\\x00-\x1f]/.test(this))
		return '"' + this.replace(/([\x00-\x1f\\"])/g,replaceFn) + '"';
	return '"' + this + '"';
};

// Parse a space-separated string of name:value parameters
// The result is an array of objects:
//   result[0] = object with a member for each parameter name, value of that member being an array of values
//   result[1..n] = one object for each parameter, with 'name' and 'value' members
String.prototype.parseParams = function(defaultName,defaultValue,allowEval,noNames,cascadeDefaults)
{
	var parseToken = function(match,p) {
		var n;
		if(match[p]) // Double quoted
			n = match[p];
		else if(match[p+1]) // Single quoted
			n = match[p+1];
		else if(match[p+2]) // Double-square-bracket quoted
			n = match[p+2];
		else if(match[p+3]) // Double-brace quoted
			try {
				n = match[p+3];
				if(allowEval)
					n = window.eval(n);
			} catch(ex) {
				throw "Unable to evaluate {{" + match[p+3] + "}}: " + exceptionText(ex);
			}
		else if(match[p+4]) // Unquoted
			n = match[p+4];
		else if(match[p+5]) // empty quote
			n = "";
		return n;
	};
	var r = [{}];
	var dblQuote = "(?:\"((?:(?:\\\\\")|[^\"])+)\")";
	var sngQuote = "(?:'((?:(?:\\\\\')|[^'])+)')";
	var dblSquare = "(?:\\[\\[((?:\\s|\\S)*?)\\]\\])";
	var dblBrace = "(?:\\{\\{((?:\\s|\\S)*?)\\}\\})";
	var unQuoted = noNames ? "([^\"'\\s]\\S*)" : "([^\"':\\s][^\\s:]*)";
	var emptyQuote = "((?:\"\")|(?:''))";
	var skipSpace = "(?:\\s*)";
	var token = "(?:" + dblQuote + "|" + sngQuote + "|" + dblSquare + "|" + dblBrace + "|" + unQuoted + "|" + emptyQuote + ")";
	var re = noNames ? new RegExp(token,"mg") : new RegExp(skipSpace + token + skipSpace + "(?:(\\:)" + skipSpace + token + ")?","mg");
	var params = [];
	do {
		var match = re.exec(this);
		if(match) {
			var n = parseToken(match,1);
			if(noNames) {
				r.push({name:"",value:n});
			} else {
				var v = parseToken(match,8);
				if(v == null && defaultName) {
					v = n;
					n = defaultName;
				} else if(v == null && defaultValue) {
					v = defaultValue;
				}
				r.push({name:n,value:v});
				if(cascadeDefaults) {
					defaultName = n;
					defaultValue = v;
				}
			}
		}
	} while(match);
	// Summarise parameters into first element
	for(var t=1; t<r.length; t++) {
		if(r[0][r[t].name])
			r[0][r[t].name].push(r[t].value);
		else
			r[0][r[t].name] = [r[t].value];
	}
	return r;
};

// Process a string list of macro parameters into an array. Parameters can be quoted with "", '',
// [[]], {{ }} or left unquoted (and therefore space-separated). Double-braces {{}} results in
// an *evaluated* parameter: e.g. {{config.options.txtUserName}} results in the current user's name.
String.prototype.readMacroParams = function()
{
	var p = this.parseParams("list",null,true,true);
	var n = [];
	for(var t=1; t<p.length; t++)
		n.push(p[t].value);
	return n;
};

// Process a string list of unique tiddler names into an array. Tiddler names that have spaces in them must be [[bracketed]]
String.prototype.readBracketedList = function(unique)
{
	var p = this.parseParams("list",null,false,true);
	var n = [];
	for(var t=1; t<p.length; t++) {
		if(p[t].value)
			n.pushUnique(p[t].value,unique);
	}
	return n;
};

// Returns array with start and end index of chunk between given start and end marker, or undefined.
String.prototype.getChunkRange = function(start,end)
{
	var s = this.indexOf(start);
	if(s != -1) {
		s += start.length;
		var e = this.indexOf(end,s);
		if(e != -1)
			return [s,e];
	}
};

// Replace a chunk of a string given start and end markers
String.prototype.replaceChunk = function(start,end,sub)
{
	var r = this.getChunkRange(start,end);
	return r ? this.substring(0,r[0]) + sub + this.substring(r[1]) : this;
};

// Returns a chunk of a string between start and end markers, or undefined
String.prototype.getChunk = function(start,end)
{
	var r = this.getChunkRange(start,end);
	if(r)
		return this.substring(r[0],r[1]);
};


// Static method to bracket a string with double square brackets if it contains a space
String.encodeTiddlyLink = function(title)
{
	return title.indexOf(" ") == -1 ? title : "[[" + title + "]]";
};

// Static method to encodeTiddlyLink for every item in an array and join them with spaces
String.encodeTiddlyLinkList = function(list)
{
	if(list) {
		var results = [];
		for(var t=0; t<list.length; t++)
			results.push(String.encodeTiddlyLink(list[t]));
		return results.join(" ");
	} else {
		return "";
	}
};

// Convert a string as a sequence of name:"value" pairs into a hashmap
String.prototype.decodeHashMap = function()
{
	var fields = this.parseParams("anon","",false);
	var r = {};
	for(var t=1; t<fields.length; t++)
		r[fields[t].name] = fields[t].value;
	return r;
};

// Static method to encode a hashmap into a name:"value"... string
String.encodeHashMap = function(hashmap)
{
	var r = [];
	for(var t in hashmap)
		r.push(t + ':"' + hashmap[t] + '"');
	return r.join(" ");
};

// Static method to left-pad a string with 0s to a certain width
String.zeroPad = function(n,d)
{
	var s = n.toString();
	if(s.length < d)
		s = "000000000000000000000000000".substr(0,d-s.length) + s;
	return s;
};

String.prototype.startsWith = function(prefix)
{
	return !prefix || this.substring(0,prefix.length) == prefix;
};

// Returns the first value of the given named parameter.
function getParam(params,name,defaultValue)
{
	if(!params)
		return defaultValue;
	var p = params[0][name];
	return p ? p[0] : defaultValue;
}

// Returns the first value of the given boolean named parameter.
function getFlag(params,name,defaultValue)
{
	return !!getParam(params,name,defaultValue);
}

// Substitute date components into a string
Date.prototype.formatString = function(template)
{
	var t = template.replace(/0hh12/g,String.zeroPad(this.getHours12(),2));
	t = t.replace(/hh12/g,this.getHours12());
	t = t.replace(/0hh/g,String.zeroPad(this.getHours(),2));
	t = t.replace(/hh/g,this.getHours());
	t = t.replace(/mmm/g,config.messages.dates.shortMonths[this.getMonth()]);
	t = t.replace(/0mm/g,String.zeroPad(this.getMinutes(),2));
	t = t.replace(/mm/g,this.getMinutes());
	t = t.replace(/0ss/g,String.zeroPad(this.getSeconds(),2));
	t = t.replace(/ss/g,this.getSeconds());
	t = t.replace(/[ap]m/g,this.getAmPm().toLowerCase());
	t = t.replace(/[AP]M/g,this.getAmPm().toUpperCase());
	t = t.replace(/wYYYY/g,this.getYearForWeekNo());
	t = t.replace(/wYY/g,String.zeroPad(this.getYearForWeekNo()-2000,2));
	t = t.replace(/YYYY/g,this.getFullYear());
	t = t.replace(/YY/g,String.zeroPad(this.getFullYear()-2000,2));
	t = t.replace(/MMM/g,config.messages.dates.months[this.getMonth()]);
	t = t.replace(/0MM/g,String.zeroPad(this.getMonth()+1,2));
	t = t.replace(/MM/g,this.getMonth()+1);
	t = t.replace(/0WW/g,String.zeroPad(this.getWeek(),2));
	t = t.replace(/WW/g,this.getWeek());
	t = t.replace(/DDD/g,config.messages.dates.days[this.getDay()]);
	t = t.replace(/ddd/g,config.messages.dates.shortDays[this.getDay()]);
	t = t.replace(/0DD/g,String.zeroPad(this.getDate(),2));
	t = t.replace(/DDth/g,this.getDate()+this.daySuffix());
	t = t.replace(/DD/g,this.getDate());
	return t;
};

Date.prototype.getWeek = function()
{
	var dt = new Date(this.getTime());
	var d = dt.getDay();
	if (d==0) d=7;// JavaScript Sun=0, ISO Sun=7
	dt.setTime(dt.getTime()+(4-d)*86400000);// shift day to Thurs of same week to calculate weekNo
	var n = Math.floor((dt.getTime()-new Date(dt.getFullYear(),0,1)+3600000)/86400000);
	return Math.floor(n/7)+1;
};

Date.prototype.getYearForWeekNo = function()
{
	var dt = new Date(this.getTime());
	var d = dt.getDay();
	if (d==0) d=7;// JavaScript Sun=0, ISO Sun=7
	dt.setTime(dt.getTime()+(4-d)*86400000);// shift day to Thurs of same week
	return dt.getFullYear();
};

Date.prototype.getHours12 = function()
{
	var h = this.getHours();
	return h > 12 ? h-12 : ( h > 0 ? h : 12 );
};

Date.prototype.getAmPm = function()
{
	return this.getHours() >= 12 ? config.messages.dates.pm : config.messages.dates.am;
};

Date.prototype.daySuffix = function()
{
	return config.messages.dates.daySuffixes[this.getDate()-1];
};

// Convert a date to local YYYYMMDDHHMM string format
Date.prototype.convertToLocalYYYYMMDDHHMM = function()
{
	return String.zeroPad(this.getFullYear(),4) + String.zeroPad(this.getMonth()+1,2) + String.zeroPad(this.getDate(),2) + String.zeroPad(this.getHours(),2) + String.zeroPad(this.getMinutes(),2);
};

// Convert a date to UTC YYYYMMDDHHMM string format
Date.prototype.convertToYYYYMMDDHHMM = function()
{
	return String.zeroPad(this.getUTCFullYear(),4) + String.zeroPad(this.getUTCMonth()+1,2) + String.zeroPad(this.getUTCDate(),2) + String.zeroPad(this.getUTCHours(),2) + String.zeroPad(this.getUTCMinutes(),2);
};

// Convert a date to UTC YYYYMMDD.HHMMSSMMM string format
Date.prototype.convertToYYYYMMDDHHMMSSMMM = function()
{
	return String.zeroPad(this.getUTCFullYear(),4) + String.zeroPad(this.getUTCMonth()+1,2) + String.zeroPad(this.getUTCDate(),2) + "." + String.zeroPad(this.getUTCHours(),2) + String.zeroPad(this.getUTCMinutes(),2) + String.zeroPad(this.getUTCSeconds(),2) + String.zeroPad(this.getUTCMilliseconds(),4);
};

// Static method to create a date from a UTC YYYYMMDDHHMM format string
Date.convertFromYYYYMMDDHHMM = function(d)
{
	return new Date(Date.UTC(parseInt(d.substr(0,4),10),
			parseInt(d.substr(4,2),10)-1,
			parseInt(d.substr(6,2),10),
			parseInt(d.substr(8,2),10),
			parseInt(d.substr(10,2),10),0,0));
};

//--
//-- RGB colour object
//--

// Construct an RGB colour object from a '#rrggbb', '#rgb' or 'rgb(n,n,n)' string or from separate r,g,b values
function RGB(r,g,b)
{
	this.r = 0;
	this.g = 0;
	this.b = 0;
	if(typeof r == "string") {
		if(r.substr(0,1) == "#") {
			if(r.length == 7) {
				this.r = parseInt(r.substr(1,2),16)/255;
				this.g = parseInt(r.substr(3,2),16)/255;
				this.b = parseInt(r.substr(5,2),16)/255;
			} else {
				this.r = parseInt(r.substr(1,1),16)/15;
				this.g = parseInt(r.substr(2,1),16)/15;
				this.b = parseInt(r.substr(3,1),16)/15;
			}
		} else {
			var rgbPattern = /rgb\s*\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)/;
			var c = r.match(rgbPattern);
			if(c) {
				this.r = parseInt(c[1],10)/255;
				this.g = parseInt(c[2],10)/255;
				this.b = parseInt(c[3],10)/255;
			}
		}
	} else {
		this.r = r;
		this.g = g;
		this.b = b;
	}
	return this;
}

// Mixes this colour with another in a specified proportion
// c = other colour to mix
// f = 0..1 where 0 is this colour and 1 is the new colour
// Returns an RGB object
RGB.prototype.mix = function(c,f)
{
	return new RGB(this.r + (c.r-this.r) * f,this.g + (c.g-this.g) * f,this.b + (c.b-this.b) * f);
};

// Return an rgb colour as a #rrggbb format hex string
RGB.prototype.toString = function()
{
	return "#" + ("0" + Math.floor(this.r.clamp(0,1) * 255).toString(16)).right(2) +
				 ("0" + Math.floor(this.g.clamp(0,1) * 255).toString(16)).right(2) +
				 ("0" + Math.floor(this.b.clamp(0,1) * 255).toString(16)).right(2);
};

//--
//-- DOM utilities - many derived from www.quirksmode.org
//--

function drawGradient(place,horiz,colours)
{
	for(var t=0; t<= 100; t+=2) {
		var bar = document.createElement("div");
		place.appendChild(bar);
		bar.style.position = "absolute";
		bar.style.left = horiz ? t + "%" : 0;
		bar.style.top = horiz ? 0 : t + "%";
		bar.style.width = horiz ? (101-t) + "%" : "100%";
		bar.style.height = horiz ? "100%" : (101-t) + "%";
		bar.style.zIndex = -1;
		var f = t/100;
		var p = f*(colours.length-1);
		bar.style.backgroundColor = colours[Math.floor(p)].mix(colours[Math.ceil(p)],p-Math.floor(p)).toString();
	}
}

function createTiddlyText(theParent,theText)
{
	return theParent.appendChild(document.createTextNode(theText));
}

function createTiddlyCheckbox(theParent,caption,checked,onChange)
{
	var cb = document.createElement("input");
	cb.setAttribute("type","checkbox");
	cb.onclick = onChange;
	theParent.appendChild(cb);
	cb.checked = checked;
	cb.className = "chkOptionInput";
	if(caption)
		wikify(caption,theParent);
	return cb;
}

function createTiddlyElement(theParent,theElement,theID,theClass,theText,attribs)
{
	var e = document.createElement(theElement);
	if(theClass != null)
		e.className = theClass;
	if(theID != null)
		e.setAttribute("id",theID);
	if(theText != null)
		e.appendChild(document.createTextNode(theText));
	if(attribs){
		for(var n in attribs){
			e.setAttribute(n,attribs[n]);
		}
	}
	if(theParent != null)
		theParent.appendChild(e);
	return e;
}

function addEvent(obj,type,fn)
{
	if(obj.attachEvent) {
		obj['e'+type+fn] = fn;
		obj[type+fn] = function(){obj['e'+type+fn](window.event);};
		obj.attachEvent('on'+type,obj[type+fn]);
	} else {
		obj.addEventListener(type,fn,false);
	}
}

function removeEvent(obj,type,fn)
{
	if(obj.detachEvent) {
		obj.detachEvent('on'+type,obj[type+fn]);
		obj[type+fn] = null;
	} else {
		obj.removeEventListener(type,fn,false);
	}
}

function addClass(e,theClass)
{
	var currClass = e.className.split(" ");
	if(currClass.indexOf(theClass) == -1)
		e.className += " " + theClass;
}

function removeClass(e,theClass)
{
	var currClass = e.className.split(" ");
	var i = currClass.indexOf(theClass);
	while(i != -1) {
		currClass.splice(i,1);
		i = currClass.indexOf(theClass);
	}
	e.className = currClass.join(" ");
}

function hasClass(e,theClass)
{
	if(e.className) {
		if(e.className.split(" ").indexOf(theClass) != -1)
			return true;
	}
	return false;
}

// Find the closest relative with a given property value (property defaults to tagName, relative defaults to parentNode)
function findRelated(e,value,name,relative)
{
	name = name ? name : "tagName";
	relative = relative ? relative : "parentNode";
	if(name == "className") {
		while(e && !hasClass(e,value)) {
			e = e[relative];
		}
	} else {
		while(e && e[name] != value) {
			e = e[relative];
		}
	}
	return e;
}

// Resolve the target object of an event
function resolveTarget(e)
{
	var obj;
	if(e.target)
		obj = e.target;
	else if(e.srcElement)
		obj = e.srcElement;
	if(obj.nodeType == 3) // defeat Safari bug
		obj = obj.parentNode;
	return obj;
}

// Prevent an event from bubbling
function stopEvent(e){
	var ev = e? e : window.event;
	ev.cancelBubble = true;
	if (ev.stopPropagation) ev.stopPropagation();
	return false;	
}

// Return the content of an element as plain text with no formatting
function getPlainText(e)
{
	var text = "";
	if(e.innerText)
		text = e.innerText;
	else if(e.textContent)
		text = e.textContent;
	return text;
}

// Get the scroll position for window.scrollTo necessary to scroll a given element into view
function ensureVisible(e)
{
	var posTop = findPosY(e);
	var posBot = posTop + e.offsetHeight;
	var winTop = findScrollY();
	var winHeight = findWindowHeight();
	var winBot = winTop + winHeight;
	if(posTop < winTop) {
		return posTop;
	} else if(posBot > winBot) {
		if(e.offsetHeight < winHeight)
			return posTop - (winHeight - e.offsetHeight);
		else
			return posTop;
	} else {
		return winTop;
	}
}

// Get the current width of the display window
function findWindowWidth()
{
	return window.innerWidth ? window.innerWidth : document.documentElement.clientWidth;
}

// Get the current height of the display window
function findWindowHeight()
{
	return window.innerHeight ? window.innerHeight : document.documentElement.clientHeight;
}

// Get the current horizontal page scroll position
function findScrollX()
{
	return window.scrollX ? window.scrollX : document.documentElement.scrollLeft;
}

// Get the current vertical page scroll position
function findScrollY()
{
	return window.scrollY ? window.scrollY : document.documentElement.scrollTop;
}

function findPosX(obj)
{
	var curleft = 0;
	while(obj.offsetParent) {
		curleft += obj.offsetLeft;
		obj = obj.offsetParent;
	}
	return curleft;
}

function findPosY(obj)
{
	var curtop = 0;
	while(obj.offsetParent) {
		curtop += obj.offsetTop;
		obj = obj.offsetParent;
	}
	return curtop;
}

// Blur a particular element
function blurElement(e)
{
	if(e != null && e.focus && e.blur) {
		e.focus();
		e.blur();
	}
}

// Create a non-breaking space
function insertSpacer(place)
{
	var e = document.createTextNode(String.fromCharCode(160));
	if(place)
		place.appendChild(e);
	return e;
}

// Remove all children of a node
function removeChildren(e)
{
	while(e && e.hasChildNodes())
		removeNode(e.firstChild);
}

// Remove a node and all it's children
function removeNode(e)
{
	scrubNode(e);
	e.parentNode.removeChild(e);
}

// Remove any event handlers or non-primitve custom attributes
function scrubNode(e)
{
	if(!config.browser.isIE)
		return;
	var att = e.attributes;
	if(att) {
		for(var t=0; t<att.length; t++) {
			var n = att[t].name;
			if(n !== 'style' && (typeof e[n] === 'function' || (typeof e[n] === 'object' && e[n] != null))) {
				try {
					e[n] = null;
				} catch(ex) {
				}
			}
		}
	}
	var c = e.firstChild;
	while(c) {
		scrubNode(c);
		c = c.nextSibling;
	}
}

// Add a stylesheet, replacing any previous custom stylesheet
function setStylesheet(s,id,doc)
{
	if(!id)
		id = "customStyleSheet";
	if(!doc)
		doc = document;
	var n = doc.getElementById(id);
	if(doc.createStyleSheet) {
		// Test for IE's non-standard createStyleSheet method
		if(n)
			n.parentNode.removeChild(n);
		// This failed without the &nbsp;
		doc.getElementsByTagName("head")[0].insertAdjacentHTML("beforeEnd","&nbsp;<style id='" + id + "'>" + s + "</style>");
	} else {
		if(n) {
			n.replaceChild(doc.createTextNode(s),n.firstChild);
		} else {
			n = doc.createElement("style");
			n.type = "text/css";
			n.id = id;
			n.appendChild(doc.createTextNode(s));
			doc.getElementsByTagName("head")[0].appendChild(n);
		}
	}
}

function removeStyleSheet(id)
{
	var e = document.getElementById(id);
	if(e)
		e.parentNode.removeChild(e);
}

// Force the browser to do a document reflow when needed to workaround browser bugs
function forceReflow()
{
	if(config.browser.isGecko) {
		setStylesheet("body {top:-1em;margin-top:1em;}");
		setStylesheet("");
	}
}

// Replace the current selection of a textarea or text input and scroll it into view
function replaceSelection(e,text)
{
	if(e.setSelectionRange) {
		var oldpos = e.selectionStart;
		var isRange = e.selectionEnd > e.selectionStart;
		e.value = e.value.substr(0,e.selectionStart) + text + e.value.substr(e.selectionEnd);
		e.setSelectionRange(isRange ? oldpos : oldpos + text.length,oldpos + text.length);
		var linecount = e.value.split('\n').length;
		var thisline = e.value.substr(0,e.selectionStart).split('\n').length-1;
		e.scrollTop = Math.floor((thisline - e.rows / 2) * e.scrollHeight / linecount);
	} else if(document.selection) {
		var range = document.selection.createRange();
		if(range.parentElement() == e) {
			var isCollapsed = range.text == "";
			range.text = text;
			if(!isCollapsed) {
				range.moveStart('character', -text.length);
				range.select();
			}
		}
	}
}

// Returns the text of the given (text) node, possibly merging subsequent text nodes
function getNodeText(e)
{
	var t = "";
	while(e && e.nodeName == "#text") {
		t += e.nodeValue;
		e = e.nextSibling;
	}
	return t;
}

//--
//-- LoaderBase and SaverBase
//--

function LoaderBase() {}

LoaderBase.prototype.loadTiddler = function(store,node,tiddlers)
{
	var title = this.getTitle(store,node);
	if(title) {
		var tiddler = store.createTiddler(title);
		this.internalizeTiddler(store,tiddler,title,node);
		tiddlers.push(tiddler);
	}
};

LoaderBase.prototype.loadTiddlers = function(store,nodes)
{
	var tiddlers = [];
	for(var t = 0; t < nodes.length; t++) {
		try {
			this.loadTiddler(store,nodes[t],tiddlers);
		} catch(ex) {
			showException(ex,config.messages.tiddlerLoadError.format([this.getTitle(store,nodes[t])]));
		}
	}
	return tiddlers;
};

function SaverBase() {}

SaverBase.prototype.externalize = function(store)
{
	var results = [];
	var tiddlers = store.getTiddlers("title");
	for(var t = 0; t < tiddlers.length; t++)
		results.push(this.externalizeTiddler(store,tiddlers[t]));
	return results.join("\n");
};

//--
//-- TW21Loader (inherits from LoaderBase)
//--

function TW21Loader() {}

TW21Loader.prototype = new LoaderBase();

TW21Loader.prototype.getTitle = function(store,node)
{
	var title = null;
	if(node.getAttribute) {
		title = node.getAttribute("title");
		if(!title)
			title = node.getAttribute("tiddler");
	}
	if(!title && node.id) {
		var lenPrefix = store.idPrefix.length;
		if (node.id.substr(0,lenPrefix) == store.idPrefix)
			title = node.id.substr(lenPrefix);
	}
	return title;
};

TW21Loader.prototype.internalizeTiddler = function(store,tiddler,title,node)
{
	var e = node.firstChild;
	var text = null;
	if(node.getAttribute("tiddler")) {
		text = getNodeText(e).unescapeLineBreaks();
	} else if (e) {
		while(e.nodeName!="PRE" && e.nodeName!="pre") {
			e = e.nextSibling;
		}
		text = e.innerHTML.replace(/\r/mg,"").htmlDecode();
	}
	var modifier = node.getAttribute("modifier");
	var c = node.getAttribute("created");
	var m = node.getAttribute("modified");
	var created = c ? Date.convertFromYYYYMMDDHHMM(c) : version.date;
	var modified = m ? Date.convertFromYYYYMMDDHHMM(m) : created;
	var tags = node.getAttribute("tags");
	var fields = {};
	var attrs = node.attributes;
	for(var i = attrs.length-1; i >= 0; i--) {
		var name = attrs[i].name;
		if (attrs[i].specified && !TiddlyWiki.isStandardField(name)) {
			fields[name] = attrs[i].value.unescapeLineBreaks();
		}
	}
	var needsLoading = node.getAttribute("needsLoading");
	tiddler.assign(title,text,modifier,modified,tags,created,fields, needsLoading);
	return tiddler;
};

//--
//-- TW21Saver (inherits from SaverBase)
//--

function TW21Saver() {}

TW21Saver.prototype = new SaverBase();

TW21Saver.prototype.externalizeTiddler = function(store,tiddler)
{
	try {
		var extendedAttributes = "";
		var usePre = config.options.chkUsePreForStorage;
		store.forEachField(tiddler,
			function(tiddler,fieldName,value) {
				// don't store stuff from the temp namespace
				if(typeof value != "string")
					value = "";
				if (!fieldName.match(/^temp\./))
					extendedAttributes += ' %0="%1"'.format([fieldName,value.escapeLineBreaks().htmlEncode()]);
			},true);
		var created = tiddler.created.convertToYYYYMMDDHHMM();
		var modified = tiddler.modified.convertToYYYYMMDDHHMM();
		var vdate = version.date.convertToYYYYMMDDHHMM();
		var attributes = tiddler.modifier ? ' modifier="' + tiddler.modifier.htmlEncode() + '"' : "";
		attributes += (usePre && modified == created) ? "" : ' modified="' + modified +'"';
		attributes += (usePre && created == vdate) ? "" :' created="' + created + '"';
		var tags = tiddler.getTags();
		if(!usePre || tags)
			attributes += ' tags="' + tags.htmlEncode() + '"';
		return ('<div %0="%1"%2%3>%4</'+'div>').format([
				usePre ? "title" : "tiddler",
				tiddler.title.htmlEncode(),
				attributes,
				extendedAttributes,
				usePre ? "\n<pre>" + tiddler.text.htmlEncode() + "</pre>\n" : tiddler.text.escapeLineBreaks().htmlEncode()
			]);
	} catch (ex) {
		throw exceptionText(ex,config.messages.tiddlerSaveError.format([tiddler.title]));
	}
};

//--
//-- End of scripts
//--
//]]>
</script>
<script type="text/javascript">
//<![CDATA[
if(useJavaSaver)
	document.write("<applet style='position:absolute;left:-1px' name='TiddlySaver' code='TiddlySaver.class' archive='TiddlySaver.jar' width='1' height='1'></applet>");
//]]>
</script>
<!--POST-SCRIPT-START-->
<!--POST-SCRIPT-END-->

<!-- for javascript debugging -->
<div id="console"></div>

</body>
</html>
