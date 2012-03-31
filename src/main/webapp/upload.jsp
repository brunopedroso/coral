<%@ page import="org.apache.commons.fileupload.FileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="java.util.List" %>


<%

// Create a factory for disk-based file items
FileItemFactory factory = new DiskFileItemFactory();

// Create a new file upload handler
ServletFileUpload upload = new ServletFileUpload(factory);

// Parse the request
List /* FileItem */ items = upload.parseRequest(request);

FileItem uploadedFile = (FileItem)items.get(0);

session.setAttribute("uploadImport", uploadedFile);

String conteudo = uploadedFile.getString();

%>