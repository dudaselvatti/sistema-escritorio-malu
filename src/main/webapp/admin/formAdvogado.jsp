<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Editar Perfil do Advogado - Escritório MaLu</title>
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/paineladmin.jsp">Meu Painel</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Sair</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container my-4 my-md-5">
    <div class="card form-container-card mx-auto" style="max-width: 800px;">
        <form action="advogado?action=atualizar" method="POST">
            
            <div class="card-header bg-white py-3">
                <h3 class="mb-0 page-title d-flex align-items-center">
                    <i class="bi bi-briefcase-fill me-2"></i> 
                    Editar Perfil de <c:out value="${advogado.nome}"/>
                </h3>
                <p class="text-muted mb-0 mt-1">Email: <c:out value="${advogado.email}"/></p>
            </div>

            <div class="card-body p-4">
                
                <input type="hidden" name="idUsuario" value="${advogado.id}" />

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="oab" class="form-label">OAB:</label>
                        <input type="text" class="form-control" id="oab" name="oab" value="<c:out value='${advogado.oab}'/>" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="especialidade" class="form-label">Especialidade:</label>
                        <select id="especialidade" name="especialidade" class="form-select">
                            <option value="Geral" ${advogado.especialidade == 'Geral' ? 'selected' : ''}>Geral</option>
                            <option value="Civil" ${advogado.especialidade == 'Civil' ? 'selected' : ''}>Direito Civil</option>
                            <option value="Criminal" ${advogado.especialidade == 'Criminal' ? 'selected' : ''}>Direito Criminal</option>
                            <option value="Trabalhista" ${advogado.especialidade == 'Trabalhista' ? 'selected' : ''}>Direito Trabalhista</option>
                            <option value="Empresarial" ${advogado.especialidade == 'Empresarial' ? 'selected' : ''}>Direito Empresarial</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="card-footer bg-white text-end py-3">
                <a href="advogado?action=listar" class="btn btn-outline-secondary me-2">
                    <i class="bi bi-x-lg me-1"></i> Cancelar
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-check-lg me-1"></i> Salvar Alterações
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