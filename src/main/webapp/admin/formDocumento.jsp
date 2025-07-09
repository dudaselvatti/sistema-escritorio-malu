<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Upload de Documento - Escritório MaLu</title>
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
       
        <form action="documento?action=upload" method="POST" enctype="multipart/form-data">
            
            <div class="card-header bg-white py-3">
                <h3 class="mb-0 page-title d-flex align-items-center">
                    <i class="bi bi-file-earmark-arrow-up-fill me-2"></i> 
                    Novo Documento
                </h3>
                <p class="text-muted mb-0 mt-1">Preencha os dados e selecione o arquivo para fazer o upload.</p>
            </div>

            <div class="card-body p-4">
                
                <c:if test="${not empty erro}">
                    <div class="alert alert-danger d-flex align-items-center" role="alert">
                        <i class="bi bi-x-octagon-fill me-2"></i>
                        <div>${erro}</div>
                    </div>
                </c:if>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="idCliente" class="form-label">Cliente:</label>
                        <select id="idCliente" name="idCliente" class="form-select" required>
                            <option value="" disabled selected>Selecione um cliente...</option>
                            <c:forEach var="cli" items="${listaClientes}"><option value="${cli.idCliente}">${cli.nome}</option></c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="idTipoDocumento" class="form-label">Tipo de Documento:</label>
                        <select id="idTipoDocumento" name="idTipoDocumento" class="form-select" required>
                            <option value="" disabled selected>Selecione um tipo...</option>
                            <c:forEach var="tipo" items="${listaTipos}"><option value="${tipo.id}">${tipo.nome}</option></c:forEach>
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="titulo" class="form-label">Título do Documento:</label>
                    <input type="text" class="form-control" id="titulo" name="titulo" placeholder="Ex: Contrato Social da Empresa" required>
                </div>

                <div class="mb-3">
                    <label for="arquivo" class="form-label">Arquivo (PDF, DOCX, JPG, etc.):</label>
                    <input class="form-control" type="file" id="arquivo" name="arquivo" required>
                </div>

                <div class="mb-3">
                    <label for="descricao" class="form-label">Descrição (opcional):</label>
                    <textarea class="form-control" id="descricao" name="descricao" rows="3" placeholder="Qualquer observação relevante sobre este documento..."></textarea>
                </div>
            </div>

            <div class="card-footer bg-white text-end py-3">
                <a href="documento?action=listar" class="btn btn-outline-secondary me-2">
                    <i class="bi bi-x-lg me-1"></i> Cancelar
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-cloud-arrow-up-fill me-1"></i> Enviar Documento
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