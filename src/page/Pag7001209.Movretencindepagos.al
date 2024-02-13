

/// <summary>
/// Page Mov. retención de pagos (ID 7001199).
/// </summary>
Page 80160 "Mov. retención de pagos"
{

    Caption = 'Mov. retención de pagos';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = "Mov. retención de pagos";
    PageType = List;
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

                field("Retention Base"; Rec."Retention Base") { ApplicationArea = All; }

                field("Retention Action"; Rec."Retention Action") { ApplicationArea = All; }

                field(Description; Rec.Description) { ApplicationArea = All; }

                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }

                field("Document Date"; Rec."Document Date") { ApplicationArea = All; }

                field("Due Date"; Rec."Due Date") { ApplicationArea = All; Editable = true; }

                field("Release Date"; Rec."Release Date") { ApplicationArea = All; }

                field("Document Type"; Rec."Document Type") { ApplicationArea = All; }

                field("Document No."; Rec."Document No.") { ApplicationArea = All; }

                field("External Document No."; Rec."External Document No.") { ApplicationArea = All; }

                field("Currency Code"; Rec."Currency Code") { ApplicationArea = All; }

                field("Retention Amount Base"; Rec."Retention Amount Base") { ApplicationArea = All; }

                field("Retention Amount Base (LCY)"; Rec."Retention Amount Base (LCY)") { ApplicationArea = All; }

                field(Amount; Rec.Amount) { ApplicationArea = All; }

                field("Amount (LCY)"; Rec."Amount (LCY)") { ApplicationArea = All; }

                field(Open; Rec.Open) { ApplicationArea = All; }

                field("Vendor Name"; Rec."Vendor Name") { ApplicationArea = All; }


            }
        }
    }
    ACTIONS
    {
        area(Navigation)
        {
            Group("&Application")
            {
                Caption = 'Li&quidación';
                Action("Release retention")
                {
                    ApplicationArea = all;
                    Scope = Repeater;
                    Caption = 'Liberar reteción';
                    Image = Action;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    VAR
                        MultiOption: Page "Date-Time Dialog";
                        Fecha: Date;
                        lRecordRef: RecordRef;
                        ReleaseDate: Date;
                        RetentionFunctions: Codeunit "Irpf";
                    BEGIN

                        // IF Type <> Type::Vendor THEN
                        //  ERROR('Solo se pueden liberar retenciones de proveedores.');

                        IF Rec."Retention Type" <> Rec."Retention Type"::"Good Execution" THEN
                            ERROR('Solo se pueden liberar retenciones de buena ejecución.');

                        IF NOT Rec.Open THEN
                            ERROR('Solo se pueden liberar retenciones abiertas.');

                        MultiOption.SetDate(WorkDate());
                        IF MultiOption.RUNMODAL In [ACTION::LookupOK, Action::OK] THEN begin
                            ReleaseDate := MultiOption.GetDate();
                        end ELSE
                            EXIT;

                        IF Rec.Type = Rec.Type::Vendor THEN
                            RetentionFunctions.ReleaseVendorRetention(Rec, ReleaseDate)
                        ELSE
                            RetentionFunctions.ReleaseCustomerRetention(Rec, ReleaseDate)


                        // CurrPage.SETSELECTIONFILTER(RecMovRetencion);
                        //
                        // //003 BM-DCB 18-12-19  Se solicita Fecha para los Efectos de la Liberación de las Retenciones
                        // //-TVL 08.10.18 fecha registro con la fechaliberacion introducida y no workingDate
                        // RecMovRetencion.SETRANGE(Open, TRUE);
                        // IF NOT RecMovRetencion.ISEMPTY THEN BEGIN
                        //  CLEAR(MultiOptionJO);
                        //  MultiOptionJO.funInitPage(0,'Fecha liberación retención', FORMAT(WORKDATE), lRecordRef);
                        //  MultiOptionJO.LOOKUPMODE:=TRUE;
                        //
                        //  IF MultiOptionJO.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        //    FechaLiberacion:=MultiOptionJO.FuncLlevarFecha;
                        //  END ELSE
                        //    EXIT;
                        // END;
                        // //+TVL 08.10.18
                        // //003 BM-DCB 18-12-19  Se solicita Fecha para los Efectos de la Liberación de las Retenciones
                        //
                        // IF RecMovRetencion.FINDSET(TRUE, TRUE) THEN BEGIN
                        //
                        //  ventana.OPEN(Text001);
                        //  RecMovRetencion2.COPY(RecMovRetencion);
                        //
                        //  REPEAT
                        //    leidos := leidos +1;
                        //    RecMovRetencion2 := RecMovRetencion;
                        //    IF Type = Type::Proveedor THEN
                        //      CduTrataRetencion.FunLiberarRetencion(RecMovRetencion2, FechaLiberacion)
                        //    ELSE
                        //      CduTrataRetencion.FunLiberarRetencionClie(RecMovRetencion2, FechaLiberacion);
                        //    ventana.UPDATE(1,leidos);
                        //  UNTIL RecMovRetencion.NEXT = 0;
                        //
                        //  ventana.CLOSE;
                        //
                        // END;
                    END;
                }
                Action("Cambiar Fecha")
                {
                    ApplicationArea = all;
                    Scope = Repeater;
                    Caption = 'Cambiar Fecha';
                    Image = ChangeDate;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    VAR
                        MultiOption: Page "Date-Time Dialog";
                        Fecha: Date;
                        lRecordRef: RecordRef;
                        ReleaseDate: Date;
                        RetentionFunctions: Codeunit "Irpf";
                    BEGIN



                        MultiOption.SetDate(WorkDate());
                        IF MultiOption.RUNMODAL In [ACTION::LookupOK, Action::OK] THEN begin
                            ReleaseDate := MultiOption.GetDate();
                        end ELSE
                            EXIT;

                        RetentionFunctions.CambiarRetentionDate(Rec, ReleaseDate)



                    END;
                }
            }
        }
        area(Processing)
        {
            action("&Navegar")
            {
                ApplicationArea = all;
                Scope = Repeater;
                Promoted = true;
                Image = Navigate;
                PromotedCategory = Process;
                trigger OnAction()
                VAR
                    NavigatePage: Page 344;
                BEGIN
                    NavigatePage.SetDoc(Rec."Posting Date", Rec."Document No.");
                    NavigatePage.RUN;
                END;
            }



        }
    }

}

