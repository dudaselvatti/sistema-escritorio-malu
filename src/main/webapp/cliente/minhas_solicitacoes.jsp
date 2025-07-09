<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Minhas Solicitações Pendentes - Escritório MaLu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">Escritório MaLu</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cliente/painelcliente.jsp">Meu Painel</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Sair</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container my-4 my-md-5">
    <div class="card form-container-card">
        
        <div class="card-header bg-white py-3">
            <h3 class="mb-0 page-title"><i class="bi bi-file-earmark-arrow-up-fill me-2"></i>Documentos Solicitados</h3>
            <p class="text-muted mb-0 mt-1">Abaixo estão os documentos que o escritório precisa que você envie.</p>
        </div>

        <div class="card-body p-4">

            <c:if test="${not empty sessionScope.mensagemSucesso}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    ${sessionScope.mensagemSucesso}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="mensagemSucesso" scope="session" />
            </c:if>

            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>Documento</th>
                            <th>Solicitado por</th>
                            <th>Data da Solicitação</th>
                            <th>Prazo Final</th>
                            <th class="text-center">Ação</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="sol" items="${listaSolicitacoes}">
                            <tr>
                                <td><c:out value="${sol.nomeTipoDocumento}" /></td>
                                <td>Adv. <c:out value="${sol.nomeAdvogado}" /></td>
                                <td><fmt:formatDate value="${sol.dataCriacao}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty sol.dataLimite}">
                                            <fmt:formatDate value="${sol.dataLimite}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Não definido</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <a href="solicitacao?action=formUpload&id=${sol.idSolicitacao}&nomeDoc=${sol.nomeTipoDocumento}&idTipoDoc=${sol.idTipoDocumento}" class="btn btn-primary btn-sm">
                                        <i class="bi bi-upload me-1"></i> Enviar Documento
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listaSolicitacoes}">
                            <tr>
                                <td colspan="5">
                                    <div class="text-center py-5">
                                        <i class="bi bi-check2-circle fs-1 text-success"></i>
                                        <h5 class="mt-3 text-success">Parabéns!</h5>
                                        <p class="text-muted">Você não possui nenhuma solicitação de documento pendente.</p>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="card-footer bg-white text-end">
             <a href="${pageContext.request.contextPath}/cliente/painelcliente.jsp" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i> Voltar ao Painel
            </a>
        </div>
    </div>
</div>

<footer class="py-4 bg-dark text-white mt-auto">
    <div class="container text-center">
        <p class="mb-0">&copy; 2025 Escritório MaLu. Todos os direitos reservados.</p>
    </div>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>