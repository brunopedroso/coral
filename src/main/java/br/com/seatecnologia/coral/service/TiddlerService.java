package br.com.seatecnologia.coral.service;

import java.util.Date;
import java.util.List;

import br.com.seatecnologia.coral.dao.TiddlerDAO;
import br.com.seatecnologia.coral.vo.Tiddler;

public class TiddlerService {
	
	private TiddlerDAO tiddlerDAO;
	
	public Tiddler loadTiddler(String namespace, String title) {
		return tiddlerDAO.loadTiddler(namespace, title);
	}

	public void setTiddlerDAO(TiddlerDAO tiddlerDAO) {
		this.tiddlerDAO = tiddlerDAO;
	}

	public List loadNamespaceTiddlers(String namespace) {
		return this.tiddlerDAO.loadNamespaceTiddlers(namespace);
	}

	/**
	 * Deleta os tiddlers cujos titulos estão em deletedTiddlersTitles;
	 * Adiciona e/ou atualiza os tiddlers em changedAddedTiddlers;
	 *  
	 * @param namespace
	 * @param changedAddedTiddlers
	 * @param deletedTiddlersTitles
	 * @param lastRead data da última leitura. Se for anterior à última alteração de algum tiddler, não permite a operação.
	 */
	public void saveUpdateDeleteTiddlers(String namespace, Tiddler[] changedAddedTiddlers, String[] deletedTiddlersTitles, Date lastRead) {
		
		for (int i=0 ; i<deletedTiddlersTitles.length ; i++) {
//			TODO verificar se a data da ultima leitura não é anterior à modified do tiddler, se ele já existir
			String t = deletedTiddlersTitles[i];
			tiddlerDAO.delete(namespace, t);
		}
		
		for (int i=0 ; i<changedAddedTiddlers.length ; i++){
			Tiddler t = changedAddedTiddlers[i];
			Tiddler lido = this.loadTiddler(t.getNamespace(), t.getTitle());
			if (lido != null) {
				lido.setTitle(t.getTitle());
				lido.setEncodedText(t.getEncodedText());
				lido.setTagsString(t.getTagsString());
				lido.setModifiedString(t.getModifiedString());
				lido.setModifier(t.getModifier());
				
				//TODO verificar se a data da ultima leitura não é anterior à modified do tiddler, se ele já existir
				
				this.tiddlerDAO.saveTiddler(lido);
				
			} else {
				this.tiddlerDAO.saveTiddler(t);
			}
		}
	}

	public String[] listNamespaces() {
		return tiddlerDAO.listNamespaces();
	}
	
	public String[] findTiddler(String pesquisa) {
		return tiddlerDAO.findTiddler(pesquisa);
	}
}
