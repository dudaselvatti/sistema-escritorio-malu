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


@WebFilter("/cliente/*")
public class ClienteAuthFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        HttpSession session = httpRequest.getSession(false);
        
        boolean isLoggedIn = (session != null && session.getAttribute("usuarioLogado") != null);
        boolean isCliente = false;

        if (isLoggedIn) {
            Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
           
            if ("cliente".equalsIgnoreCase(usuario.getTipoUsuario())) {
                isCliente = true;
            }
        }
        
        if (isCliente) {
            
            chain.doFilter(request, response);
        } else {
           
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/index.jsp");
        }
    }
    
    public void init(FilterConfig fConfig) throws ServletException {}
    public void destroy() {}
}
