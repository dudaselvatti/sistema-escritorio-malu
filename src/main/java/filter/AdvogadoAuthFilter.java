package filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Usuario;


@WebFilter("/advogado/*")
public class AdvogadoAuthFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        HttpSession session = httpRequest.getSession(false);
        
        boolean isLoggedIn = (session != null && session.getAttribute("usuarioLogado") != null);
        boolean isAdvogado = false;

        if (isLoggedIn) {
            Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
           
            if ("advogado".equalsIgnoreCase(usuario.getTipoUsuario())) {
                isAdvogado = true;
            }
        }
        
        if (isAdvogado) {
        
            chain.doFilter(request, response);
        } else {
            
            System.out.println("ACESSO NEGADO: Tentativa de acesso à área de advogado sem permissão.");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/naoAutorizado.jsp");
        }
    }
    
    public void init(FilterConfig fConfig) throws ServletException {}
    public void destroy() {}
}
