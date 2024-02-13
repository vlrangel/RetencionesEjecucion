
/// <summary>
/// Table Grupo de retención de pagos (ID 7001171).
/// </summary>
table 7001231 "Grupo de retención de pagos"
{
    //CaptionML=[ENU=Payments on Hold Group;
    Caption = 'Grupo de retención de pagos';
    LookupPageID = "Grupos de retención de pagos";
    DrillDownPageID = "Grupos de retención de pagos";

    FIELDS
    {
        field(1; Code; Code[20])
        {
            ; DataClassification = ToBeClassified;
            //CaptionML=[ENU=Code;
            Caption = 'Código';
        }
        field(2; Description; Text[50])
        {
            ; DataClassification = ToBeClassified;
            //CaptionML=[ENU=Description;
            Caption = 'Descripción';
        }
        field(3; "Retention Type"; Option)
        {
            ; DataClassification = ToBeClassified;
            //CaptionML=[ENU=Retention Type;
            Caption = 'Tipo retención';
            //OptionCaptionML=[ENU=Good Execution,IRPF;
            OptionCaption = 'Buena ejecución,IRPF';
            OptionMembers = "Good Execution",IRPF;
        }
        field(4; "Retention Base"; Option)
        {
            ; DataClassification = ToBeClassified;
            //CaptionML=[ENU=Retention Base;
            Caption = 'Base de retención';
            //OptionCaptionML=[ENU=Amount,Amount Including VAT;
            OptionCaption = 'Importe factura,Importe IVA incluido';
            OptionMembers = "Invoce Amount","VAT with Amount";
            Editable = false;
        }
        field(5; "% Retention"; Decimal)
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=% Retention;
            Caption = 'Retención %';
        }
        field(6; "Retention Action"; Option)
        {
            ; DataClassification = ToBeClassified;
            //CaptionML=[ENU=Retention Action;
            Caption = 'Acción retención';
            //OptionCaptionML=[ENU=Payment On Hold,Pending Invoice;
            OptionCaption = 'Retención pago,Pendiente factura';
            OptionMembers = "Payment Hold","Pending Invoice";
            Editable = false;
        }
        field(7; "Warranty Period"; DateFormula)
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Warranty Period;
            Caption = 'Periodo de garantía';
        }
        field(8; "Account No."; Code[20])
        {
            ; TableRelation = "G/L Account";
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=Account No.;
            Caption = 'Nº cuenta';
        }
        field(9; "Referencia Cat. Obligatoria"; Boolean) { }
    }
    KEYS
    {
        Key(PK; Code) { Clustered = true; }
    }
    FIELDGROUPS
    {
    }

}

