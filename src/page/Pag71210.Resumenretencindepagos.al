

/// <summary>
/// Page Mov. retención de pagos (ID 7001199).
/// </summary>
<<<<<<< HEAD:src/page/Pag71210.Resumenretencindepagos.al
Page 71210 "Resumen retención de pagos"
=======
Page 80161 "Resumen retención de pagos"
>>>>>>> a9ee88a3eea46a4406956a6351f27f14826149ef:src/page/Pag7001210.Resumenretencindepagos.al
{

    Caption = 'Resumen retención de pagos';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = "Mov. retención de pagos";
    PageType = List;
    SourceTableTemporary = true;
    UsageCategory = Lists;
    ApplicationArea = All;
    Permissions = tabledata "Purch. Inv. Header" = rimd,
    tabledata "Purch. Inv. Line" = rimd, tabledata "Purchase Header" = rimd,
    tabledata "Purchase Line" = rimd, tabledata "Sales Cr.Memo Header" = rimd,
    tabledata "Sales Cr.Memo Line" = rimd, tabledata "Sales Invoice Header" = rimd,
    tabledata "Sales Invoice Line" = rimd, tabledata "Sales Header" = rimd,
    tabledata "Sales Line" = rimd;

    layout
    {
        area(Content)
        {

            Repeater(detalle)
            {

                field(Type; Rec.Type) { ApplicationArea = All; }

                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Cuenta Retención"; Rec."Cuenta Retención")
                {
                    ApplicationArea = All;
                }


                field("Retention Group Code"; Rec."Retention Group Code") { ApplicationArea = All; }

                field("Retention Type"; Rec."Retention Type") { ApplicationArea = All; }


                field("Retention Action"; Rec."Retention Action") { ApplicationArea = All; }

                field(Nombre; Rec.Description) { ApplicationArea = All; }

                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }

                field("Base Retención"; Rec."Retention Amount Base") { ApplicationArea = All; }
                field(Importe; Rec.Amount) { ApplicationArea = All; }

                field("Document Type"; Rec."Document Type") { ApplicationArea = All; }

                field("Referencia Catastral"; Rec."Referencia Catastral") { ApplicationArea = All; }
                field("Vendor Name"; Rec."Vendor Name") { ApplicationArea = All; }
                field("Dirección"; RefCat.Address) { ApplicationArea = All; }
                field("Dirección 2"; RefCat."Address 2") { ApplicationArea = All; }
                field("Cif"; RefCat.Cif) { ApplicationArea = All; }
                field("Pais"; RefCat."Country/Region Code") { ApplicationArea = All; }
                field("Provincia"; RefCat."County") { ApplicationArea = All; }
                field("Cód Postal"; RefCat."Post Code") { ApplicationArea = All; }
                field("Población"; RefCat."City") { ApplicationArea = All; }

            }
        }
    }
    ACTIONS
    {

        area(Processing)
        {
            action("Generar &Resumen")
            {
                ApplicationArea = all;
                Scope = Repeater;
                Promoted = true;
                Image = Navigate;
                PromotedCategory = Process;
                trigger OnAction()
                VAR
                    MovRetencion: Record "Mov. retención de pagos";
                    a: Integer;
                    Vendor: Record Vendor;
                    PurchInvLine: Record "Purch. Inv. Line";
                    PurchCrMemoLine: Record "Purch. Cr. Memo Line";
                    Code: Text[35];
                    GrupoRetencion: Record "Grupo de retención de pagos";
                BEGIN
                    MovRetencion.SETRANGE("Posting Date", CalcDate('PA+1D-2A', WorkDate()), CalcDate('PA-1A', WorkDate()));
                    MovRetencion.SetRange(Type, MovRetencion.Type::Vendor);
                    If MovRetencion.FindFirst() Then
                        Repeat
                            GrupoRetencion.Get(MovRetencion."Retention Group Code");
                            if (MovRetencion."Referencia Catastral" = '') And (GrupoRetencion."Referencia Cat. Obligatoria") Then begin
                                RefCat.SETRANGE("Code");
                                Vendor.get(MovRetencion."No.");
                                RefCat.reset;
                                RefCat.SetRange("Vendor No.", movretencion."No.");
                                RefCat.SETRANGE(Code, MovRetencion."No.");
                                if not RefCat.FindFirst() Then begin
                                    RefCat.Init();
                                    RefCat.Code := MovRetencion."No.";
                                    RefCat."Vendor No." := MovRetencion."No.";
                                    RefCat.Address := Vendor.Address;
                                    RefCat."Address 2" := Vendor."Address 2";
                                    RefCat.Cif := Vendor."VAT Registration No.";
                                    RefCat."Country/Region Code" := Vendor."Country/Region Code";
                                    RefCat."County" := Vendor."County";
                                    RefCat."Post Code" := Vendor."Post Code";
                                    RefCat."City" := Vendor."City";
                                    RefCat.Name := Vendor.Name;
                                    RefCat.Insert();
                                end;
                                Case MovRetencion."Document Type" Of
                                    MovRetencion."Document Type"::Invoice:
                                        begin
                                            PurchInvLine.SETRANGE("Document No.", MovRetencion."Document No.");
                                            if PurchInvLine.FindFirst() Then begin
                                                Code := MovRetencion."No.";
                                                RefCat.SETRANGE("Code");
                                                RefCat.SetRange("Vendor No.", movretencion."No.");
                                                RefCat.SETRANGE(Code, Code);
                                                if not RefCat.FindFirst() Then RefCat.SetRange(Code, MovRetencion."No.");
                                                if RefCat.FindFirst() Then begin
                                                    RefCat."Vendor No." := MovRetencion."No.";
                                                    if RefCat.Address = '' then
                                                        RefCat.Address := Vendor.Address;
                                                    if RefCat."Address 2" = '' then
                                                        RefCat."Address 2" := Vendor."Address 2";
                                                    if RefCat.Cif = '' then
                                                        RefCat.Cif := Vendor."VAT Registration No.";
                                                    if RefCat."Country/Region Code" = '' then
                                                        RefCat."Country/Region Code" := Vendor."Country/Region Code";
                                                    if RefCat."County" = '' then
                                                        RefCat."County" := Vendor."County";
                                                    if RefCat."Post Code" = '' then
                                                        RefCat."Post Code" := Vendor."Post Code";
                                                    if RefCat."City" = '' then
                                                        RefCat."City" := Vendor."City";
                                                    if RefCat.Name = '' then
                                                        RefCat.Name := Vendor.Name;
                                                    RefCat.Modify();
                                                    MovRetencion."Referencia Catastral" := RefCat."Ref. Catastral";
                                                    MovRetencion.Modify();
                                                end;
                                            end;
                                        end;
                                    MovRetencion."Document Type"::"Credit Memo":
                                        begin
                                            PurchCRMemoLine.SETRANGE("Document No.", MovRetencion."Document No.");
                                            if PurchCRMemoLine.FindFirst() Then begin
                                                Code := MovRetencion."No.";
                                                RefCat.SETRANGE("Code");
                                                RefCat.SetRange("Vendor No.", movretencion."No.");
                                                RefCat.SETRANGE(Code, Code);
                                                if not RefCat.FindFirst() Then RefCat.SetRange(Code, MovRetencion."No.");
                                                if RefCat.FindFirst() Then begin
                                                    RefCat."Vendor No." := MovRetencion."No.";
                                                    if RefCat.Address = '' then
                                                        RefCat.Address := Vendor.Address;
                                                    if RefCat."Address 2" = '' then
                                                        RefCat."Address 2" := Vendor."Address 2";
                                                    if RefCat.Cif = '' then
                                                        RefCat.Cif := Vendor."VAT Registration No.";
                                                    if RefCat."Country/Region Code" = '' then
                                                        RefCat."Country/Region Code" := Vendor."Country/Region Code";
                                                    if RefCat."County" = '' then
                                                        RefCat."County" := Vendor."County";
                                                    if RefCat."Post Code" = '' then
                                                        RefCat."Post Code" := Vendor."Post Code";
                                                    if RefCat."City" = '' then
                                                        RefCat."City" := Vendor."City";
                                                    if RefCat.Name = '' then
                                                        RefCat.Name := Vendor.Name;
                                                    MovRetencion."Referencia Catastral" := RefCat."Ref. catastral";
                                                    RefCat.Modify();
                                                    MovRetencion.Modify();
                                                end;
                                            end;
                                        end;

                                end;
                            end;
                            Rec.Reset();
                            Rec.SetRange("No.", MovRetencion."No.");
                            Rec.SetRange("Referencia Catastral", MovRetencion."Referencia Catastral");
                            if not Rec.FindFirst() Then begin
                                a += 1;
                                Rec := MovRetencion;
                                rec."Posting Date" := CalcDate('PA-1A', WorkDate());
                                Rec."Document Date" := CalcDate('PA-1A', WorkDate());
                                Rec."Due Date" := CalcDate('PA-1A', WorkDate());
                                Rec."Release Date" := CalcDate('PA-1A', WorkDate());
                                Rec."Document Type" := Rec."Document Type"::" ";
                                Rec."Document No." := '';
                                Rec."Referencia Catastral" := MovRetencion."Referencia Catastral";
                                Rec."Entry No." := a;
                                Rec.Insert();
                            end else begin
                                rec.Amount := rec.Amount + MovRetencion.Amount;
                                rec."Amount (LCY)" := rec."Amount (LCY)" + MovRetencion."Amount (LCY)";
                                rec."Retention Amount Base" := rec."Retention Amount Base" + MovRetencion."Retention Amount Base";
                                rec."Retention Amount Base (LCY)" := rec."Retention Amount Base (LCY)" + MovRetencion."Retention Amount Base (LCY)";
                                rec."Retention Base" := rec."Retention Base" + MovRetencion."Retention Base";
                                rec.Modify();

                            end;
                        until MovRetencion.Next() = 0;
                    rec.Reset();
                    CurrPage.Update();
                END;
            }



        }
    }
    var
        RefCat: Record "Ref Catastral Address";

    trigger OnAfterGetRecord()
    var
        Vendor: Record Vendor;
    begin
        RefCat.Reset();
        RefCat.SetRange("Vendor No.", Rec."No.");
        RefCat.SetRange("Ref. catastral", Rec."Referencia Catastral");
        If Not Vendor.Get(Rec."No.") Then
            Vendor.Init();
        If not RefCat.FindFirst() Then begin
            RefCat.Init();
            RefCat.Code := Rec."No.";
            RefCat."Vendor No." := Rec."No.";
            RefCat.Address := Vendor.Address;
            RefCat."Address 2" := Vendor."Address 2";
            RefCat.Cif := Vendor."VAT Registration No.";
            RefCat."Country/Region Code" := Vendor."Country/Region Code";
            RefCat."County" := Vendor."County";
            RefCat."Post Code" := Vendor."Post Code";
            RefCat."City" := Vendor."City";
            RefCat.Name := Vendor.Name;
        end;
        if RefCat.Cif = '' Then refcat.Cif := Vendor."VAT Registration No.";
    end;
}

