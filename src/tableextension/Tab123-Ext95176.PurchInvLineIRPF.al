/// <summary>
/// TableExtension Purch. Inv. LineIRPF (ID 80176) extends Record Purch. Inv. Line.
/// </summary>
tableextension 95176 "Purch. Inv. LineIRPF" extends "Purch. Inv. Line" //123
{
    fields
    {

        field(91000; "% retención (BE)"; Decimal)
        {
            DataClassification = ToBeClassified;

            Caption = '% retención (BE)';
            Editable = false;
        }
        field(92001; "% retención (IRPF)"; Decimal)
        {
            DataClassification = ToBeClassified;

            Caption = '% retención (IRPF)';
            Editable = false;
        }
        field(92002; "Importe retención (BE)"; Decimal)
        {
            DataClassification = ToBeClassified;

            Caption = 'Importe retención (BE)';
            Editable = false;
        }
        field(92003; "Importe retención (IRPF)"; Decimal)
        {
            DataClassification = ToBeClassified;

            Caption = 'Importe retención (IRPF)';
            Editable = false;
        }
        field(92004; "Ref. catastral inmueble SII"; TEXT[30])
        {
            DataClassification = ToBeClassified;

            Caption = 'Ref. catastral inmueble SII';
        }


    }
}
