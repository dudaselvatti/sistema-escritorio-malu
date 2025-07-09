<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${not empty processo ? 'Editar' : 'Novo'} Processo - Escritório MaLu</title>
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/advogado/paineladvogado.jsp">Meu Painel</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Sair</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container my-4 my-md-5">
    <div class="card form-container-card mx-auto" style="max-width: 800px;">
        <form action="processo?action=${not empty processo ? 'atualizar' : 'inserir'}" method="POST">
            
            <div class="card-header bg-white py-3">
                <h3 class="mb-0 page-title d-flex align-items-center">
                    <i class="bi bi-folder-plus me-2"></i> 
                    ${not empty processo ? 'Editar' : 'Novo'} Processo
                </h3>
            </div>

            <div class="card-body p-4">
                
                <c:if test="${not empty processo}">
                    <input type="hidden" name="id" value="${processo.idProcesso}" />
                </c:if>
                <input type="hidden" name="idAdvogado" value="${advogadoLogado.idAdvogado}">

                <div class="row">
                    <div class="col-12 mb-3">
                        <label for="idCliente" class="form-label">Cliente:</label>
                        <select id="idCliente" name="idCliente" class="form-select" required>
                            <option value="">Selecione um cliente...</option>
                            <c:forEach var="cli" items="${listaClientes}">
                                <option value="${cli.idCliente}" ${processo.idCliente == cli.idCliente ? 'selected' : ''}>
                                    <c:out value="${cli.nome}" />
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-12 mb-3">
                        <label for="descricao" class="form-label">Descrição do Processo:</label>
                        <textarea class="form-control" id="descricao" name="descricao" rows="5" required><c:out value="${processo.descricao}"/></textarea>
                    </div>

                    <div class="col-12 mb-3">
                        <label for="status" class="form-label">Status:</label>
     				<select id="status" name="status" class="form-select">
					   
					    <option value="em analise" ${processo.status == 'em analise' ? 'selected' : ''}>Em Análise</option>
					    <option value="concluído" ${processo.status == 'concluído' ? 'selected' : ''}>Concluído</option>
					    <option value="cancelado" ${processo.status == 'cancelado' ? 'selected' : ''}>Cancelado</option>
					</select>
                    </div>
                </div>
            </div>

            <div class="card-footer bg-white text-end py-3">
                <a href="processo?action=listar" class="btn btn-outline-secondary me-2">
                    <i class="bi bi-x-lg me-1"></i> Cancelar
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-check-lg me-1"></i> Salvar
                </button>
            </div>
        </form>
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