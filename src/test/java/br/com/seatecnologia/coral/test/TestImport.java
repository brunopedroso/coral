package br.com.seatecnologia.coral.test;

import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import br.com.seatecnologia.coral.vo.Tiddler;
import br.com.seatecnologia.coral.web.UploadImportHelper;

import junit.framework.TestCase;

public class TestImport extends TestCase {
	
	/**
	 * Tests if we are extracting the storeArea div correctly
	 * @throws Exception
	 */
	public void testExtractStoreArea() throws Exception {

		// reads the test tiddly wiki
		InputStream is = ClassLoader.getSystemClassLoader().getResourceAsStream("br/com/seatecnologia/coral/test/almost_empty.html");
		assertNotNull(is);
		
		String storeArea = UploadImportHelper.extractStoreArea(is);
		
		assertTrue(storeArea.startsWith("<div id=\"storeArea\">\n<div title=\""));
		assertTrue(storeArea.endsWith("</div>\n</div>\n<!--POST-STOREAREA-->"));
		
	}
	
	/**
	 * Tests if we are correctly creating the tiddler from its div representation
	 *
	 */
	public void testCreateTiddlerFromDiv() {
		String div = "<div title=\"MyNewTiddler\" modifier=\"YourName\" modified=\"200804061720\" created=\"200804061448\" changecount=\"2\">\n<pre>Testing the tiddlers import of coral</pre>\n</div>";
		Tiddler t = new Tiddler(div);
		
		assertEquals("MyNewTiddler",t.getTitle());
		assertEquals("YourName",t.getModifier());
		assertEquals("200804061720",t.getModifiedString());
		assertEquals("200804061448",t.getCreatedString());
		assertEquals("<pre>Testing the tiddlers import of coral</pre>",t.getEncodedText());
		
	}
	

	/**
	 * Tests if we are correctly extracting the tiddler list from a string representing the storeArea
	 * 
	 * @throws Exception
	 */
	public void testExtractTiddlersFromStoreArea() throws Exception {
		
		// reads the test tiddly wiki
		InputStream is = ClassLoader.getSystemClassLoader().getResourceAsStream("br/com/seatecnologia/coral/test/almost_empty.html");
		assertNotNull(is);
		
		String storeArea = UploadImportHelper.extractStoreArea(is);
		
		List l = UploadImportHelper.getTiddlersFromStoreArea(storeArea);
		
		assertEquals(6, l.size());
		Iterator it = l.iterator();
		int count = 0;
		while(it.hasNext()){
			
			Tiddler t = (Tiddler) it.next();
			
			if (t.getTitle().equals("MyNewTiddler")) {
				assertEquals("<pre>Testing the tiddlers import of coral</pre>", t.getEncodedText());
				count++;
			}
			
			if (t.getTitle().equals("OneMoreTiddler")) {
				assertEquals("<pre>This is another one I've created</pre>", t.getEncodedText());
				count++;
			}
			
		}
		assertEquals(2, count);
	}
	
	/**
	 * Tests the regExp used in Tiddler.attributesToMap(String att)... 
	 * TODO Its coppied there, don't call it from here...
	 *
	 */
	public void testRegExp() {

		// matches something like "key=\"value\""
		Pattern pat = Pattern.compile("([^\"=]*)=\"([^\"]*)\"", Pattern.MULTILINE);
		Matcher m = pat.matcher(new StringBuffer(" chave1=\"válorç1\" chave2=\"valor2 valor3\""));
		
		assertTrue(m.find());
		// theres an intentional special character here
		assertEquals("chave1=\"válorç1\"", m.group());
		assertEquals("chave1", m.group(1));
		assertEquals("válorç1", m.group(2));

		assertTrue(m.find());
		assertEquals("chave2=\"valor2 valor3\"", m.group());
		assertEquals("chave2", m.group(1));
		assertEquals("valor2 valor3", m.group(2));

	}
	
}
