package br.com.seatecnologia.coral.vo;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.tools.ant.filters.StringInputStream;

public class Tiddler {

	public Tiddler() {
		
	}
	
	/**
	 * Creates a new Tiddler from its div representation, as TW uses to store.
	 * @param divRepresentation
	 */
	public Tiddler(String divRepresentation) {
	
		int startIndex = divRepresentation.indexOf("<div ");
		
		if (startIndex <0) {
			throw new IllegalArgumentException("Can't parse tiddler div. Couldn't find start of tag");
		}
		
		int endOpenTagIndex = divRepresentation.indexOf(">");
		if (endOpenTagIndex <0) {
			throw new IllegalArgumentException("Can't parse tiddler div. Couldn't find end of tag openning");
		}
		
		int endTagIndex = divRepresentation.indexOf("</div>");
		if (endTagIndex <0) {
			throw new IllegalArgumentException("Can't parse tiddler div. Couldn't find tag closing");
		}
		
		String tagAtributes = divRepresentation.substring(startIndex+4, endOpenTagIndex);
		String tiddlerContent = divRepresentation.substring(endOpenTagIndex+1, endTagIndex).trim();
		
		//  NOP! the <pre> tag need to stay here so the client cant detect if it needs escapeLineBreaks
		//
		//if (tiddlerContent.startsWith("<pre>")){
		//	// New TW puts a <pre> tag arround the content
		//	int begin = "<pre>".length();
		//	int end = tiddlerContent.length() - "</pre>".length();
		//	tiddlerContent = tiddlerContent.substring(begin, end);
		//}
		
		Map attributes = attributesToMap(tagAtributes);
		
		String title = (String) attributes.get("title");
		if (title != null) {
			setTitle((String) attributes.get("title"));
		} else {
			// for compatibility with old TW
			setTitle((String) attributes.get("tiddler"));
		}
		
		setCreatedString((String) attributes.get("created"));
		setModifiedString((String) attributes.get("modified"));
		setModifier((String) attributes.get("modifier"));
		setTagsString((String) attributes.get("tags"));
		
		setEncodedText(tiddlerContent.trim());
	}
	
	private Map attributesToMap(String att) {
		
		// matches something like "key=\"value\""
		Pattern pat = Pattern.compile("([^\"=]*)=\"([^\"]*)\"", Pattern.MULTILINE);
		Matcher m = pat.matcher(new StringBuffer(att));
		
		Map map = new HashMap();
		while(m.find()){
			map.put(m.group(1).trim(), m.group(2).trim());
		}
		
		return map;
	}
	
	private Integer id;

	private String namespace;

	private String title;

	private String encodedText;

	private String tagsString;

	private String createdString;

	private String modifiedString;

	private String modifier;

	private static final Map shadowed = new HashMap();
	static {
		shadowed.put("StyleSheet", "");
		shadowed.put("StyleSheetColors", "");
		shadowed.put("StyleSheetLayout", "");
		shadowed.put("StyleSheetPrint", "");
		shadowed.put("PageTemplate", "");
		shadowed.put("ViewTemplate", "");
		shadowed.put("EditTemplate", "");
		shadowed.put("MarkupPreHead", "");
		shadowed.put("MarkupPostHead", "");
		shadowed.put("MarkupPreBody", "");
		shadowed.put("MarkupPostBody", "");
		shadowed.put("DefaultTiddlers", "");
		shadowed.put("MainMenu", "");
		shadowed.put("SiteTitle", "");
		shadowed.put("SiteSubtitle", "");
		shadowed.put("SiteUrl", "");
		shadowed.put("GettingStarted", "");
		shadowed.put("SideBarOptions", "");
		shadowed.put("OptionsPanel: ", "");
		shadowed.put("AdvancedOptions", "");
		shadowed.put("SideBarTabs", "");
		shadowed.put("TabTimeline", "");
		shadowed.put("TabAll", "");
		shadowed.put("TabTags", "");
		shadowed.put("TabMore", "");
		shadowed.put("TabMoreMissing", "");
		shadowed.put("TabMoreOrphans", "");
		shadowed.put("TabMoreShadowed", "");


	}

	public String getModifiedString() {
		return modifiedString;
	}

	public void setModifiedString(String modified) {
		this.modifiedString = modified;
	}

	public String getModifier() {
		return modifier;
	}

	public void setModifier(String modifier) {
		this.modifier = modifier;
	}

	public String getTagsString() {
		return tagsString;
	}

	public void setTagsString(String tagsString) {
		this.tagsString = tagsString;
	}

	public String getEncodedText() {
		return encodedText;
	}

	public void setEncodedText(String text) {
	    this.encodedText = text;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getCreatedString() {
		return createdString;
	}

	public void setCreatedString(String created) {
		this.createdString = created;
	}

	public String getNamespace() {
		return namespace;
	}

	public void setNamespace(String namespace) {
		this.namespace = namespace;
	}

	public String getHtmlDiv() {
		
		// <div tiddler="TestTiddler" modifier="BrunoPedroso"
		// modified="200608171503" created="200608171503" tags=""
		// needsLoading="true"></div>
		StringBuffer sb = new StringBuffer();

		// new tiddler format encolses the content with a <pre> 
		// it is verified in the internalizeTiddler function of TW
		if (getEncodedText().startsWith("<pre>")){
			sb.append("<div title=\"");
		} else {
			sb.append("<div tiddler=\"");
		}
		
		sb.append(getTitle());
		sb.append("\" modifier=\"");
		sb.append(getModifier());
		sb.append("\" modified=\"");
		sb.append(getModifiedString());
		sb.append("\" created=\"");
		sb.append(getCreatedString());
		sb.append("\" tags=\"");
		sb.append(getTagsString());

		if (isShadowed() || isSysConfig()) {
			// pr� leitura dos tiddlers que s�o shadowed e dos que possuem a tag
			// systemConfig
			sb.append("\" >" + getEncodedText() + "</div>");
		} else {
			sb.append("\" needsLoading=\"true\"></div>");
		}

		return sb.toString();
	}

	// there was a NullPOinterException being throwed in case of reading orphan Tiddlers
	private boolean isSysConfig() {
		return getTagsString() == null ? false : getTagsString().indexOf("systemConfig") >= 0;
	}

	private boolean isShadowed() {
		return shadowed.containsKey(getTitle());
	}

}
