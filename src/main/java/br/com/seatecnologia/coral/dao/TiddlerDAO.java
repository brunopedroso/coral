package br.com.seatecnologia.coral.dao;

import java.util.List;

import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import br.com.seatecnologia.coral.vo.Tiddler;

public class TiddlerDAO extends HibernateDaoSupport {
	
	public Tiddler loadTiddler(String namespace, String title) {
		List lista = getHibernateTemplate().find(
				"from Tiddler where namespace=? and title=?",
				new Object[] { namespace, title });
		
		if (lista.size()>1) {
			throw new RuntimeException("Mais de um tiddler com o mesmo nome, no mesmo namespace. Não deveria ocorrer.");
		} else if (lista.size()==0) {
			return null;
		} else {
			return (Tiddler) lista.get(0);
		}
	}

	public List loadNamespaceTiddlers(String namespace) {
		return getHibernateTemplate().find(
				"from Tiddler where namespace=?",
				new Object[] { namespace });
	}

	public void saveTiddler(Tiddler t) {
		//System.out.println("salvando " + t.getTitle());
		getHibernateTemplate().saveOrUpdate(t);
	}

	public void delete(String namespace, String title) {
		//System.out.println("deletando " + title);
		Tiddler t = loadTiddler(namespace, title);
		if (t != null) {
			getHibernateTemplate().delete(t);
		}
	}

	public String[] listNamespaces() {
		List l = getHibernateTemplate().find(
		"select distinct t.namespace from Tiddler t");
		String[] ns = new String[l.size()];
		return (String[]) l.toArray(ns);
	}

	public String[] findTiddler(String pesquisa) {
		List l = getHibernateTemplate().find(
				"from Tiddler where text like ?",
				new Object[] { "%" + pesquisa + "%" });
		String[] tiddlers = new String[l.size()];
		
		for (int i = 0; i < l.size(); i++) {
			Tiddler tiddler = (Tiddler) l.get(i);
			tiddlers[i] = tiddler.getTitle(); 
		}
		
		return tiddlers;
	}
}
