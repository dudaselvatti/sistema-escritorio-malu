<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Meus Processos - Escritório MaLu</title>
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
            <h3 class="mb-0 page-title"><i class="bi bi-folder-fill me-2"></i>Meus Processos</h3>
            <p class="text-muted mb-0 mt-1">Acompanhe aqui o andamento de seus casos.</p>
        </div>

        <div class="card-body p-4">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>Nº Processo</th>
                            <th>Advogado Responsável</th>
                            <th>Descrição</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="proc" items="${listaProcessos}">
                            <tr>
                                <td><strong>#${proc.idProcesso}</strong></td>
                                <td><c:out value="${proc.nomeAdvogado}" /></td>
                                <td><c:out value="${proc.descricao}" /></td>
                                <td class="text-capitalize">
                                     <c:choose>
                                        <c:when test="${proc.status == 'concluído'}">
                                            <span class="badge bg-success"><i class="bi bi-check2-circle me-1"></i> ${proc.status}</span>
                                        </c:when>
                                        <c:when test="${proc.status == 'cancelado'}">
                                            <span class="badge bg-danger"><i class="bi bi-x-circle me-1"></i> ${proc.status}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-primary"><i class="bi bi-hourglass-split me-1"></i> ${proc.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listaProcessos}">
                            <tr>
                                <td colspan="4">
                                    <div class="text-center py-5">
                                        <i class="bi bi-folder-x fs-1 text-muted"></i>
                                        <h5 class="mt-3">Nenhum Processo Encontrado</h5>
                                        <p class="text-muted">Você ainda não possui processos cadastrados em seu nome.</p>
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