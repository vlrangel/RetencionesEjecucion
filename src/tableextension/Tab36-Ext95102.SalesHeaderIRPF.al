/// <summary>
/// TableExtension SalesHeaderIRPF (ID 80102) extends Record Sales Header.
/// </summary>
tableextension 95102 SalesHeaderIRPF extends "Sales Header"//36
{
    fields
    {

        // Add changes to table fields here


        field(92000; "Código grupo retención (BE)"; Code[20])
        {
            TableRelation = "Grupo de retención de pagos".Code WHERE("Retention Type" = CONST("Good Execution"));
            DataClassification = ToBeClassified;

            Caption = 'Código grupo retención (BE)';
        }
        field(92001; "Código grupo retención (IRPF)"; Code[20])
        {
            TableRelation = "Grupo de retención de pagos".Code WHERE("Retention Type" = CONST(IRPF));
            DataClassification = ToBeClassified;

            Caption = 'Código grupo retención (IRPF)';
        }
        field(92002; "Importe retención (BE)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Importe retención (BE)" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                               "Document No." = FIELD("No.")));

            Caption = 'Importe retención (BE)';
            Editable = false;
        }
        field(92003; "Importe retención (IRPF)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Importe retención (IRPF)" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                                 "Document No." = FIELD("No.")));

            Caption = 'Importe retención (IRPF)';
            Editable = false;
        }

    }


}