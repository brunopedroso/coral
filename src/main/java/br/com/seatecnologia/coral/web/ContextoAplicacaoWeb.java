package br.com.seatecnologia.coral.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 * Ponto de acesso ao contexto do spring a partir da camada web.
 * @author BrunoPedroso
 *
 */
public class ContextoAplicacaoWeb {
	
    public static Object getBean(HttpServletRequest req, String nome) {
        WebApplicationContext contexto = (WebApplicationContext) WebApplicationContextUtils
                .getWebApplicationContext(req.getSession().getServletContext());

        return contexto.getBean(nome);
    }
	
}
