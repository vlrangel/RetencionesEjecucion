

/// <summary>
/// Table 'Mov. retención de pagos (ID 7001173).
/// </summary>
table 71232 "Mov. retención de pagos"
{

    //CaptionML=[ENU=Mov. retención de pagosy;
    Caption = 'Mov. retención de pagos';
    LookupPageID = "Mov. retención de pagos";
    DrillDownPageID = "Mov. retención de pagos";

    FIELDS
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Entry No.;
            Caption = 'Nº mov.';
        }
        field(2; Type; Option)
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Type;
            Caption = 'Tipo';
            //OptionCaptionML=[ENU=Vendor,Customer;
            OptionCaption = 'Proveedor,Cliente';
            OptionMembers = Vendor,Customer;
        }
        field(3; "No."; Code[20])
        {
            TableRelation = IF (Type = CONST(Vendor)) Vendor
            ELSE
            IF (Type = CONST(Customer)) Customer;
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=No.;
            Caption = 'Nº';
            Editable = false;
        }
        field(4; "Retention Group Code"; Code[20])
        {
            TableRelation = "Grupo de retención de pagos";
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Retention Group Code;
            Caption = 'Código grupo retención';
        }
        field(5; "Retention Type"; Option)
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Retention Type;
            Caption = 'Tipo retención';
            //OptionCaptionML=[ENU=Good Execution,IRPF;
            OptionCaption = 'Buena ejecución,IRPF';
            OptionMembers = "Good Execution",IRPF;
        }
        field(6; "Retention Base"; Option)
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Retention Base;
            Caption = 'Base de retención';
            //OptionCaptionML=[ENU=Amount,Amount Including VAT;
            OptionCaption = 'Importe factura,Importe IVA incluido';
            OptionMembers = "Invoce Amount","VAT with Amount";
        }
        field(7; "Retention Action"; Option)
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Retention Action;
            Caption = 'Acción retención';
            //OptionCaptionML=[ENU=Payment On Hold,Pending Invoice;
            OptionCaption = 'Retención pago,Pendiente factura';
            OptionMembers = "Payment Hold","Pending Invoice";
        }
        field(8; Description; Text[50])
        {
            ; DataClassification = ToBeClassified;
            //CaptionML=[ENU=Description;
            Caption = 'Descripción';
        }
        field(9; "Posting Date"; Date)
        {
            ; DataClassification = ToBeClassified;
            //CaptionML=[ENU=Posting Date;
            Caption = 'Fecha registro';
            Editable = false;
        }
        field(10; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Document Date;
            Caption = 'Fecha emisión documento';
        }
        field(11; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Due Date;
            Caption = 'Fecha vencimiento';
            //  Editable = false;
        }
        field(12; "Release Date"; Date)
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Release Date;
            Caption = 'Fecha liberación';
            Editable = false;
        }
        field(13; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Document No.;
            Caption = 'Nº documento';
            Editable = false;
            TableRelation = if ("Document Type" = const(Invoice), Type = const(Vendor)) "Purch. Inv. Header"
            else
            If ("Document Type" = const(Invoice), Type = const(Customer)) "Sales Invoice Header"
            else
            if ("Document Type" = const("Credit Memo"), Type = const(Vendor)) "Purch. Cr. Memo Hdr."
            else
            If ("Document Type" = const("Credit Memo"), Type = const(Customer)) "Sales Cr.Memo Header";
        }
        field(14; "External Document No."; Code[35])
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=External Document No.;
            Caption = 'Nº documento externo';
        }
        field(15; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
            DataClassification = ToBeClassified;

            Caption = 'Cód. divisa';
            Editable = false;
        }
        field(16; "Retention Amount Base"; Decimal)
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Retention Amount Base;
            Caption = 'Importe base de retención';
            Editable = false;
            AutoFormatType = 1;
            //AutoFormatExpr="Document No." 
        }
        field(17; "Retention Amount Base (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Retention Amount Base (LCY);
            Caption = 'Importe base de retención (DL)';
            Editable = false;
            AutoFormatType = 1;
            //AutoFormatExpr="Document No." 
        }
        field(18; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Amount;
            Caption = 'Importe';
            Editable = false;
            AutoFormatType = 1;
            //AutoFormatExpr="Document No." 
        }
        field(19; "Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Amount (LCY);
            Caption = 'Importe (DL)';
            Editable = false;
            AutoFormatType = 1;
        }
        field(20; Open; Boolean)
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Open;
            Caption = 'Pendiente';
            Editable = true;
        }
        field(21; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Document Type;
            Caption = 'Tipo documento';
            //OptionCaptionML=[ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,,,,,,,,,,,,,,,Bill";
            OptionCaption = ' ,Pago,Factura,Abono,Docs. interés,Recordatorio,Reembolso,,,,,,,,,,,,,,,Efecto';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,,,,,,,,,,,,,,,Bill;
        }
        field(22; "Vendor Name"; Text[150])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("No.")));
            //CaptionML=[ENU=Vendor Name;
            Caption = 'Nombre proveedor';
        }
        field(23; "Cuenta Retención"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Grupo de retención de pagos"."Account No." where(Code = Field("Retention Group Code")));

        }
        field(24; "Referencia Catastral"; Text[50])
        {


        }


    }
    KEYS
    {
        Key(Pk; "Entry No.") { Clustered = true; }
    }
    FIELDGROUPS
    {
    }

}