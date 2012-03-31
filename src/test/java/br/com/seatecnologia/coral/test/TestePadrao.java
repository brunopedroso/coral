/*
 * Criado em 02/11/2004
 */
package br.com.seatecnologia.coral.test;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Calendar;
import java.util.Date;
import java.util.StringTokenizer;

import junit.framework.TestCase;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 
 * @author Bruno Pedroso
 *  
 */
public abstract class TestePadrao extends TestCase {
	
    /** para os testes poderem testar os servicos */
    private static BeanFactory factory_;
    
    private static String script;
    
    protected Object getBean(String nome) {
        return factory_.getBean(nome);
    }
    
    
    public void setUp() throws Exception {

        if (factory_ == null) {
            factory_ = new ClassPathXmlApplicationContext(new String[]{"applicationContext.xml", "dataSource_test.xml"});
        }

        Session sessao = ((SessionFactory)factory_.getBean("sessionFactory")).openSession();
        zerarBase(sessao, false);
    }

    /**
     * 
     * @param path diretorio onde estao os scrits sql
     * @throws HibernateException
     * @throws IOException
     * @throws ClassNotFoundException
     * @throws SQLException
     */
    public static void zerarBase(Session sessao, boolean relerScripts) throws HibernateException, IOException, ClassNotFoundException, SQLException {
        
        if (script == null || relerScripts) {
        	script = leArquivo("target/test-classes/delete.sql");
        }

        try {
            executaScript(script, sessao);
        } catch (HibernateException e) {
            e.printStackTrace();
            throw e;
        
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        
        sessao.flush();
        sessao.close();
        
    }

    protected void tearDown() throws Exception {
        

    }

    /**
     * 
     * @param path
     * @throws IOException
     * @throws ClassNotFoundException
     * @throws SQLException
     * @throws HibernateException
     */
    private static void executaScript(String todosScripts, Session sessao) throws IOException, ClassNotFoundException,
            SQLException, HibernateException {

        //Connection con = getConexaoBanco();
        Connection con = sessao.connection();
        con.setAutoCommit(false);

        Statement st = con.createStatement();

        // separa os comandos sql por ponto e vírgula
        StringTokenizer tok = new StringTokenizer(todosScripts, ";", false);
        while (tok.hasMoreTokens()) {
            String comando = tok.nextToken().trim();
            
            if (comando.length() > 0) {
                // executa um por um pra ver melhor no teste
                st.execute(comando);
                
            }
        }

        con.commit();
        
    }

    /**
     * @throws ClassNotFoundException
     * @throws SQLException //
     */
    private static String leArquivo(String nome) throws IOException {

        FileInputStream fis = new FileInputStream(nome);
        StringWriter buf = new StringWriter();

        int caractere = fis.read();
        while (caractere != -1) {
            buf.write(caractere);
            caractere = fis.read();
        }

        return buf.toString();
    }
    
    /**
     * Testa só o dia, mês e o ano.
     */
    protected void assertDatasIguais(Date d1, Date d2) {
    	
		Calendar cal1 = Calendar.getInstance();
		Calendar cal2 = Calendar.getInstance();
		cal1.setTime(d1);
		cal2.setTime(d2);
		
		assertEquals("dia", cal1.get(Calendar.DAY_OF_MONTH), cal2.get(Calendar.DAY_OF_MONTH));
		assertEquals("mes", cal1.get(Calendar.MONTH), cal2.get(Calendar.MONTH));
		assertEquals("ano", cal1.get(Calendar.YEAR), cal2.get(Calendar.YEAR));
    }

}