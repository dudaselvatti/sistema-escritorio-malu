<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${not empty tipoDoc ? 'Editar' : 'Novo'} Tipo de Documento</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/personalizadoform.css" rel="stylesheet">
</head>
<body>
    <div class="container my-4" style="max-width: 600px;">
        <h3>${not empty tipoDoc ? 'Editar' : 'Novo'} Tipo de Documento</h3>
        <hr>

        <c:if test="${not empty erro}">
            <div class="alert alert-danger">${erro}</div>
        </c:if>

        <form action="tipoDocumento?action=${not empty tipoDoc ? 'atualizar' : 'inserir'}" method="POST">
            <c:if test="${not empty tipoDoc}">
                <input type="hidden" name="id" value="${tipoDoc.id}">
            </c:if>
            <div class="mb-3">
                <label for="nome" class="form-label">Nome:</label>
                <input type="text" class="form-control" id="nome" name="nome" value="<c:out value='${tipoDoc.nome}'/>" required>
            </div>
            <button type="submit" class="btn btn-primary">Salvar</button>
            <a href="tipoDocumento?action=listar" class="btn btn-secondary">Cancelar</a>
        </form>
    </div>
</body>
</html>
