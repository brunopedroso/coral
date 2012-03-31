package br.com.seatecnologia.coral.test;

import java.util.Date;
import java.util.List;

import br.com.seatecnologia.coral.service.TiddlerService;
import br.com.seatecnologia.coral.vo.Tiddler;

public class TiddlerServiceTest extends TestePadrao {
	
	public void testLoadTiddler() {
		
		Tiddler t = getTestTiddler();

		TiddlerService service = (TiddlerService) getBean("tiddlerService");
		service.saveUpdateDeleteTiddlers("main", new Tiddler[]{t}, new String[0], new Date());
		
		t = service.loadTiddler("main", "TestTiddler");
				
		assertEquals("main", t.getNamespace());
		assertEquals("TestTiddler", t.getTitle());
		assertEquals("this is a [[Tiddler]] that im using to test.", t.getEncodedText());
		assertEquals("welcome test", t.getTagsString());
		assertEquals("200607132248", t.getCreatedString());
		assertEquals("200607132249", t.getModifiedString());
		assertEquals("BrunoPedroso", t.getModifier());

		assertNull(service.loadTiddler("namespaceInexistente", "TestTiddler"));
		assertNull(service.loadTiddler("TestNamespace", "TiddlerInexistente"));
	}
	
	public void testWriteToDiv() {
		
		String esperado = "<div tiddler=\"TestTiddler\" modifier=\"BrunoPedroso\" modified=\"200607132249\" created=\"200607132248\" tags=\"welcome test\" needsLoading=\"true\"></div>";
		
		Tiddler t = getTestTiddler();
		
		assertEquals(esperado, t.getHtmlDiv());
	}

	public void testLoadNamespaceTiddlers() {
		
		Tiddler t1 = getTestTiddler();
		
		Tiddler t2 = getTestTiddler();
		t2.setTitle("Tiddler");
		
		Tiddler t3 = getTestTiddler();
		t3.setTitle("OutroTiddler");

		// esse nao deve vir
		Tiddler t4 = getTestTiddler();
		t4.setTitle("TiddlerDoOutroNamespace");
		t4.setNamespace("OutroNamespace");
		
		TiddlerService service = (TiddlerService) getBean("tiddlerService");
		service.saveUpdateDeleteTiddlers("main", new Tiddler[]{t1, t2, t3, t4}, new String[0], new Date());
		
		List tiddlers = service.loadNamespaceTiddlers("main");
		
		assertEquals(3, tiddlers.size());
		assertEquals("TestTiddler", ((Tiddler)tiddlers.get(0)).getTitle());
		assertEquals("Tiddler", ((Tiddler)tiddlers.get(1)).getTitle());
		assertEquals("OutroTiddler", ((Tiddler)tiddlers.get(2)).getTitle());
	}

	private Tiddler getTestTiddler() {
		Tiddler t = new Tiddler();
		t.setNamespace("main");
		t.setTitle("TestTiddler");
		t.setEncodedText("this is a [[Tiddler]] that im using to test.");
		t.setModifier("BrunoPedroso");
		t.setModifiedString("200607132249");
		t.setCreatedString("200607132248");
		t.setTagsString("welcome test");
		return t;
	}
	
	public void testSaveUpdateDeleteTiddlers() {
		
		TiddlerService service = (TiddlerService) getBean("tiddlerService");
		
		// certifica-se de que o banco esta vazio
		assertEquals(0, service.loadNamespaceTiddlers("main").size());
		
		// cria 3 tiddlers
		Tiddler t1 = getTestTiddler();
		
		Tiddler t2 = getTestTiddler();
		t2.setTitle("SegundoTiddler");
		
		Tiddler t3 = getTestTiddler();
		t3.setTitle("OutroTiddler");

		service.saveUpdateDeleteTiddlers("main", new Tiddler[]{t1, t2, t3}, new String[]{}, new Date());

		// verifica se salvou
		assertEquals(3, service.loadNamespaceTiddlers("main").size());
		comparaTiddlers(t1, service.loadTiddler(t1.getNamespace(), t1.getTitle()));
		comparaTiddlers(t2, service.loadTiddler(t2.getNamespace(), t2.getTitle()));
		comparaTiddlers(t3, service.loadTiddler(t3.getNamespace(), t3.getTitle()));

		// cria um novo
		Tiddler t4 = getTestTiddler();
		t4.setTitle("UmNovoTiddler");

		// edita soh o texto do t1
		t1.setEncodedText("mudei o texto");
		
		// edita o texto e renomeia o t2
		t2.setEncodedText("aqui mudei o texto");
		t2.setTitle("TiddlerRenomeado");
		
		// cria o t4, edita t1 e t2 e exclui o t3
		service.saveUpdateDeleteTiddlers("main", new Tiddler[]{t1, t2, t4}, new String[]{t3.getTitle()}, new Date());
		
		// verifica o novo
		comparaTiddlers(t4, service.loadTiddler(t4.getNamespace(), t4.getTitle()));
		
		// verifica os editados
		comparaTiddlers(t1, service.loadTiddler(t1.getNamespace(), t1.getTitle()));
		comparaTiddlers(t2, service.loadTiddler(t2.getNamespace(), t2.getTitle()));
	
		// ve se o tiddler renomeado nao continua no banco
		assertNull(service.loadTiddler("main", "SegundoTiddler"));

		// ve se excluiu o t3
		assertNull(service.loadTiddler(t3.getNamespace(), t3.getTitle()));
	}

	private void comparaTiddlers(Tiddler esperado, Tiddler aTestar) {
		assertEquals(esperado.getNamespace(), aTestar.getNamespace());
		assertEquals(esperado.getTitle(), aTestar.getTitle());
		assertEquals(esperado.getEncodedText(), aTestar.getEncodedText());
		assertEquals(esperado.getTagsString(), aTestar.getTagsString());
		assertEquals(esperado.getCreatedString(), aTestar.getCreatedString());
		assertEquals(esperado.getModifiedString(), aTestar.getModifiedString());
		assertEquals(esperado.getModifier(), aTestar.getModifier());
	}
	
	public void testSaveTiddlersJaAlterados() {
		// se a data de ultima leitura for posterior aa alteracao de algum tiddler sendo salvo, volta erro.
	}

	public void testListNamespaces() {
		
		TiddlerService service = (TiddlerService) getBean("tiddlerService");
		assertEquals(0, service.listNamespaces().length);
		
		// cria 2 tiddlers no mesmo namespace
		Tiddler t1 = getTestTiddler();
		Tiddler t2 = getTestTiddler();
		t2.setTitle("SegundoTiddler");
		
		service.saveUpdateDeleteTiddlers("main", new Tiddler[]{t1, t2}, new String[]{}, new Date());
		
		assertEquals(1, service.listNamespaces().length);

		// cria um tiddler em outro namespace
		Tiddler t3 = getTestTiddler();
		t3.setNamespace("outroNamespace");
		t3.setTitle("TerceiroTiddler");
		
		service.saveUpdateDeleteTiddlers("outroNamespace", new Tiddler[]{t3}, new String[]{}, new Date());
		
		String[] namespaces = service.listNamespaces();
		assertEquals(2, namespaces.length);
		assertEquals("main", namespaces[0]);
		assertEquals("outroNamespace", namespaces[1]);

		// apaga o unico tiddler de um namespace 
		service.saveUpdateDeleteTiddlers("outroNamespace", new Tiddler[]{}, new String[]{"TerceiroTiddler"}, new Date());
		assertEquals(1, service.listNamespaces().length);
	}
	
	public void testSearchTiddler() {
		String pesquisa = "Tiddler";
		
		TiddlerService service = (TiddlerService) getBean("tiddlerService");

		// cria 3 tiddlers
		Tiddler t1 = getTestTiddler();
		
		Tiddler t2 = getTestTiddler();
		t2.setTitle("SegundoTiddler");
		
		Tiddler t3 = getTestTiddler();
		t3.setTitle("OutroTiddler");

		service.saveUpdateDeleteTiddlers("main", new Tiddler[]{t1, t2, t3}, new String[]{}, new Date());
		
		String[] tiddlersPesquisados = service.findTiddler(pesquisa);

		assertEquals(3, tiddlersPesquisados.length);
	}
}
