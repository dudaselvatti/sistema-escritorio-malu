<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Enviar Documento - Escritório MaLu</title>
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
    <div class="card form-container-card mx-auto" style="max-width: 700px;">
        
        <form action="${pageContext.request.contextPath}/cliente/upload" method="POST" enctype="multipart/form-data">
            
            <div class="card-header bg-white py-3">
                <h3 class="mb-0 page-title d-flex align-items-center">
                    <i class="bi bi-file-earmark-arrow-up-fill me-2"></i> 
                    Enviar Documento
                </h3>
                <p class="text-muted mb-0 mt-1">Você está respondendo à solicitação de: <strong><c:out value="${param.nomeDoc}"/></strong></p>
            </div>

            <div class="card-body p-4">
                
                <input type="hidden" name="idSolicitacao" value="${param.id}">
                <input type="hidden" name="idTipoDocumento" value="${param.idTipoDoc}">
                <input type="hidden" name="titulo" value="${param.nomeDoc} - ${sessionScope.usuarioLogado.nome}">

                <div class="mb-3">
                    <label for="arquivo" class="form-label">Selecione o arquivo para enviar:</label>
                    <input class="form-control form-control-lg" type="file" id="arquivo" name="arquivo" required>
                    <div class="form-text mt-2">Formatos aceitos: PDF, JPG, PNG, DOCX. Tamanho máximo: 10MB.</div>
                </div>
            </div>

            <div class="card-footer bg-white text-end py-3">
                <a href="${pageContext.request.contextPath}/cliente/solicitacao" class="btn btn-outline-secondary me-2">
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