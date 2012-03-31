package br.com.seatecnologia.coral.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import uk.ltd.getahead.dwr.WebContextFactory;
import javax.servlet.http.HttpSession;
import org.apache.commons.fileupload.FileItem;

import br.com.seatecnologia.coral.vo.Tiddler;

public class UploadImportHelper {
	
	
	public static List getTiddlers() {
		
		HttpSession session = WebContextFactory.get().getSession();
		FileItem fi = (FileItem)session.getAttribute("uploadImport"); 
		
		try {
			
			String store = extractStoreArea(fi.getInputStream());
			return getTiddlersFromStoreArea(store);
			
		} catch (IOException e) {
			// just to convert in a non-obrigatory one...
			throw new RuntimeException("couldn't extract storeArea properly", e);
		}
		
	}
	
	/**
	 * Parses a list of tiddlers from a string representing the storeArea of tiddlyWiki
	 * 
	 * @param storeArea
	 * @return
	 */
	public static List getTiddlersFromStoreArea(String storeArea) {
		
		List list = new ArrayList();
		
		String openStoreArea = "<div id=\"storeArea\">"; 

		int openStoreAreaIndex = storeArea.indexOf(openStoreArea);
		int lastClosingDivIndex = storeArea.lastIndexOf("</div>");
		
		if (openStoreAreaIndex < 0 || lastClosingDivIndex < 0) {
			return null;
		}
		
		// the same string but without the openning and closing of storeArea div
		String onlyDivs = storeArea.substring(openStoreAreaIndex+openStoreArea.length(), lastClosingDivIndex);
		
		int divBeginIndex = onlyDivs.indexOf("<div");
		int divEndIndex = onlyDivs.indexOf("</div>");
		
		while (divBeginIndex >= 0) {
			Tiddler tiddler = new Tiddler(onlyDivs.substring(divBeginIndex, divEndIndex + "</div>".length() ));
			list.add(tiddler);
			
			divBeginIndex = onlyDivs.indexOf("<div", divEndIndex);
			divEndIndex = onlyDivs.indexOf("</div>", divBeginIndex);
		}
		
		return list;
		
	}
	
	public static String extractStoreArea(InputStream is) throws IOException {
		BufferedReader reader = new BufferedReader(new InputStreamReader(is));
		
		String linha = null;
		
		// reads until the beginning of the storeArea
		while((linha=reader.readLine()) != null && linha.indexOf("<div id=\"storeArea\">") < 0) {
		}
		
		StringBuffer sb = new StringBuffer();
		sb.append(linha);
		sb.append("\n");
		
		// reads the storeArea
		while((linha=reader.readLine()) != null && linha.indexOf("<!--POST-STOREAREA-->") < 0) {
			sb.append(linha);
			sb.append("\n");
		}
		
		// includes the last line
		sb.append(linha);
		
		// end reading
		is.close();
		
		return sb.toString();
	}
	
	/**
	 * Parses the storeArea div from an original TiddlyWiki file. It's used in the import function.
	 * 
	 * @param storeArea
	 * @return
	 */
	public List loadTiddlersFromDivs(String storeArea) {
		return null;
	}

	
}