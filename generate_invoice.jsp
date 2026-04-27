<%@ page import="java.sql.*, java.io.*, com.itextpdf.text.*, com.itextpdf.text.pdf.*" %>
<%
    String customerId = request.getParameter("id");
    if(customerId == null){
        out.println("Customer ID missing!");
        return;
    }

    Connection con = null;
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/inventory_system","root","kashish890");

    PreparedStatement psCust = con.prepareStatement(
        "SELECT * FROM customers WHERE id=?"
    );
    psCust.setInt(1, Integer.parseInt(customerId));
    ResultSet rsCust = psCust.executeQuery();

    if(!rsCust.next()){
        out.println("Customer not found!");
        return;
    }

    String cname = rsCust.getString("customer_name");
    String email = rsCust.getString("email");
    String mobile = rsCust.getString("mobile1");


    PreparedStatement psInv = con.prepareStatement(
        "SELECT * FROM invoices WHERE customer_id=? ORDER BY date DESC LIMIT 1"
    );
    psInv.setInt(1, Integer.parseInt(customerId));
    ResultSet rsInv = psInv.executeQuery();

    if(!rsInv.next()){
        out.println("No invoices found for this customer!");
        return;
    }

    int invoiceId = rsInv.getInt("id");
    Timestamp date = rsInv.getTimestamp("date");
    double subtotal = rsInv.getDouble("sub_total");
    double discount = rsInv.getDouble("discount");
    double tax = rsInv.getDouble("tax");
    double shipping = rsInv.getDouble("shipping");
    double grandTotal = rsInv.getDouble("grand_total");

    PreparedStatement psItems = con.prepareStatement(
        "SELECT * FROM invoice_items WHERE invoice_id=?"
    );
    psItems.setInt(1, invoiceId);
    ResultSet rsItems = psItems.executeQuery();

response.setContentType("application/pdf");
response.setHeader("Content-Disposition", "attachment; filename=Invoice_" + invoiceId + ".pdf");

Document document = new Document();
PdfWriter.getInstance(document, response.getOutputStream());
document.open();


BaseColor primary = new BaseColor(37, 99, 235);   
BaseColor secondary = new BaseColor(99, 102, 241); 
BaseColor borderColor = new BaseColor(180, 190, 255); 


Font title = new Font(Font.FontFamily.HELVETICA, 24, Font.BOLD, BaseColor.WHITE);
Font headerFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD, BaseColor.WHITE);
Font bold = new Font(Font.FontFamily.HELVETICA, 13, Font.BOLD, primary);
Font normal = new Font(Font.FontFamily.HELVETICA, 12);

PdfPTable headerBar = new PdfPTable(1);
headerBar.setWidthPercentage(100);

PdfPCell headerCell = new PdfPCell(new Phrase("INVENTORY MANAGEMENT SYSTEM", title));
headerCell.setBackgroundColor(primary);
headerCell.setPadding(18);
headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);
headerCell.setBorder(Rectangle.NO_BORDER);
headerBar.addCell(headerCell);
document.add(headerBar);

PdfPTable top = new PdfPTable(2);
top.setWidthPercentage(100);
top.setSpacingBefore(10);

PdfPCell left = new PdfPCell();
left.setBorder(Rectangle.NO_BORDER);
left.addElement(new Paragraph("Electronics Shop\nSonipat, India\nPhone: +91 7988592752", normal));

PdfPCell right = new PdfPCell();
right.setBorder(Rectangle.NO_BORDER);
right.setHorizontalAlignment(Element.ALIGN_RIGHT);
right.addElement(new Paragraph("Invoice No: INV-" + invoiceId, bold));
right.addElement(new Paragraph("Date: " + date, normal));
left.setBorder(Rectangle.BOX);
left.setBorderColor(borderColor);
left.setPadding(10);

right.setBorder(Rectangle.BOX);
right.setBorderColor(borderColor);
right.setPadding(10);
top.addCell(left);
top.addCell(right);

document.add(top);

PdfPTable bill = new PdfPTable(1);
bill.setWidthPercentage(100);
bill.setSpacingBefore(10);

PdfPCell billCell = new PdfPCell();
billCell.setBackgroundColor(secondary);
billCell.setBorder(Rectangle.BOX);
billCell.setBorderColor(borderColor);
billCell.setPadding(12);

billCell.addElement(new Paragraph("BILL TO", headerFont));
billCell.addElement(new Paragraph(cname, new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.WHITE)));
billCell.addElement(new Paragraph(email, new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL, BaseColor.WHITE)));
billCell.addElement(new Paragraph(mobile, new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL, BaseColor.WHITE)));

bill.addCell(billCell);
document.add(bill);

PdfPTable table = new PdfPTable(4);
table.setWidthPercentage(100);
table.setSpacingBefore(10);
table.setWidths(new float[]{4,2,1,2});

String[] cols = {"Product", "Price", "Qty", "Total"};
for(String c : cols){
	PdfPCell cell = new PdfPCell(new Phrase(c, headerFont));
	cell.setBackgroundColor(primary);
	cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	cell.setPadding(10);
	cell.setBorderColor(borderColor);
    table.addCell(cell);
}


boolean alternate = false;

while(rsItems.next()){
    BaseColor rowColor = alternate ? new BaseColor(230, 235, 255) : new BaseColor(210, 220, 255);
    alternate = !alternate;

    PdfPCell c1 = new PdfPCell(new Phrase(rsItems.getString("product_name"), normal));
    c1.setBackgroundColor(rowColor);
    c1.setBorderColor(borderColor);

    PdfPCell c2 = new PdfPCell(new Phrase(" " + rsItems.getDouble("price"), bold));
    c2.setHorizontalAlignment(Element.ALIGN_RIGHT);
    c2.setBackgroundColor(rowColor);
    c2.setBorderColor(borderColor);

    PdfPCell c3 = new PdfPCell(new Phrase("" + rsItems.getInt("qty"), bold));
    c3.setHorizontalAlignment(Element.ALIGN_CENTER);
    c3.setBackgroundColor(rowColor);
    c3.setBorderColor(borderColor);

    PdfPCell c4 = new PdfPCell(new Phrase(" " + rsItems.getDouble("total"), bold));
    c4.setHorizontalAlignment(Element.ALIGN_RIGHT);
    c4.setBackgroundColor(rowColor);
    c4.setBorderColor(borderColor);

    table.addCell(c1);
    table.addCell(c2);
    table.addCell(c3);
    table.addCell(c4);
}

document.add(table);

PdfPTable total = new PdfPTable(2);
total.setWidthPercentage(40);
total.setHorizontalAlignment(Element.ALIGN_RIGHT);
total.setSpacingBefore(10);

total.addCell("Subtotal"); total.addCell(" " + subtotal);
total.addCell("Discount"); total.addCell(" " + discount);
total.addCell("Tax"); total.addCell("" + tax);
total.addCell("Shipping"); total.addCell(" " + shipping);

PdfPCell g1 = new PdfPCell(new Phrase("Grand Total", headerFont));
g1.setBackgroundColor(primary);
g1.setPadding(10);
g1.setBorderColor(borderColor);

PdfPCell g2 = new PdfPCell(new Phrase(" " + grandTotal, headerFont));
g2.setBackgroundColor(secondary);
g2.setPadding(10);
g2.setBorderColor(borderColor);

total.addCell(g1);
total.addCell(g2);
document.add(total);

Paragraph footer = new Paragraph("\n Thank you for your business! ", bold);
footer.setAlignment(Element.ALIGN_CENTER);
document.add(footer);

Paragraph note = new Paragraph("Developed by Smart IMS", new Font(Font.FontFamily.HELVETICA, 9));
note.setAlignment(Element.ALIGN_CENTER);
document.add(note);
document.close();
%>