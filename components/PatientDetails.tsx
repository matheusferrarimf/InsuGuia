import { useState } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from './ui/card';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { Label } from './ui/label';
import { Tabs, TabsContent, TabsList, TabsTrigger } from './ui/tabs';
import { Badge } from './ui/badge';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, ReferenceLine } from 'recharts';
import { Activity, Edit, Save, X } from 'lucide-react';
import type { Patient } from '../App';

interface PatientDetailsProps {
  patient: Patient;
  onUpdatePatient: (patient: Patient) => void;
}

export function PatientDetails({ patient, onUpdatePatient }: PatientDetailsProps) {
  const [isEditing, setIsEditing] = useState(false);
  const [editedPatient, setEditedPatient] = useState(patient);

  // Dados simulados de glicemia para o gráfico
  const glycemiaHistory = [
    { time: '00:00', value: 120, target: 120 },
    { time: '06:00', value: 145, target: 120 },
    { time: '12:00', value: 186, target: 120 },
    { time: '18:00', value: 158, target: 120 },
    { time: '22:00', value: 142, target: 120 },
  ];

  const handleSave = () => {
    onUpdatePatient(editedPatient);
    setIsEditing(false);
  };

  const handleCancel = () => {
    setEditedPatient(patient);
    setIsEditing(false);
  };

  return (
    <div className="space-y-6">
      {/* Patient Header */}
      <Card>
        <CardHeader>
          <div className="flex justify-between items-start">
            <div>
              <CardTitle className="flex items-center gap-2">
                <Activity className="w-5 h-5 text-indigo-600" />
                {patient.name}
              </CardTitle>
              <CardDescription className="mt-1">
                Detalhes completos e histórico do paciente
              </CardDescription>
            </div>
            {!isEditing ? (
              <Button variant="outline" onClick={() => setIsEditing(true)}>
                <Edit className="w-4 h-4 mr-2" />
                Editar
              </Button>
            ) : (
              <div className="flex gap-2">
                <Button variant="outline" onClick={handleCancel}>
                  <X className="w-4 h-4 mr-2" />
                  Cancelar
                </Button>
                <Button onClick={handleSave}>
                  <Save className="w-4 h-4 mr-2" />
                  Salvar
                </Button>
              </div>
            )}
          </div>
        </CardHeader>
        <CardContent>
          <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
            <div className="space-y-1">
              <p className="text-sm text-gray-500">Idade</p>
              {isEditing ? (
                <Input
                  type="number"
                  value={editedPatient.age}
                  onChange={(e) => setEditedPatient({ ...editedPatient, age: parseInt(e.target.value) })}
                />
              ) : (
                <p>{patient.age} anos</p>
              )}
            </div>
            <div className="space-y-1">
              <p className="text-sm text-gray-500">Peso</p>
              {isEditing ? (
                <Input
                  type="number"
                  step="0.1"
                  value={editedPatient.weight}
                  onChange={(e) => setEditedPatient({ ...editedPatient, weight: parseFloat(e.target.value) })}
                />
              ) : (
                <p>{patient.weight} kg</p>
              )}
            </div>
            <div className="space-y-1">
              <p className="text-sm text-gray-500">Data de Admissão</p>
              <p>{new Date(patient.admission).toLocaleDateString('pt-BR')}</p>
            </div>
            <div className="space-y-1">
              <p className="text-sm text-gray-500">Última Glicemia</p>
              <p>
                {patient.lastGlycemia ? (
                  <Badge className={
                    patient.lastGlycemia < 70 ? 'bg-red-500' :
                    patient.lastGlycemia <= 140 ? 'bg-green-500' :
                    patient.lastGlycemia <= 180 ? 'bg-yellow-500' :
                    'bg-red-500'
                  }>
                    {patient.lastGlycemia} mg/dL
                  </Badge>
                ) : (
                  <span className="text-gray-400">Não registrado</span>
                )}
              </p>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Tabs */}
      <Tabs defaultValue="glycemia" className="w-full">
        <TabsList className="grid w-full grid-cols-3">
          <TabsTrigger value="glycemia">Controle Glicêmico</TabsTrigger>
          <TabsTrigger value="insulin">Insulinoterapia</TabsTrigger>
          <TabsTrigger value="clinical">Dados Clínicos</TabsTrigger>
        </TabsList>

        <TabsContent value="glycemia" className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle>Histórico de Glicemia</CardTitle>
              <CardDescription>
                Evolução das últimas 24 horas
              </CardDescription>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={300}>
                <LineChart data={glycemiaHistory}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="time" />
                  <YAxis domain={[0, 250]} />
                  <Tooltip />
                  <Legend />
                  <ReferenceLine y={70} stroke="#ef4444" strokeDasharray="3 3" label="Hipoglicemia" />
                  <ReferenceLine y={140} stroke="#22c55e" strokeDasharray="3 3" label="Meta Superior" />
                  <ReferenceLine y={180} stroke="#f59e0b" strokeDasharray="3 3" label="Hiperglicemia" />
                  <Line
                    type="monotone"
                    dataKey="value"
                    stroke="#4f46e5"
                    strokeWidth={2}
                    name="Glicemia"
                    dot={{ fill: '#4f46e5', r: 5 }}
                  />
                </LineChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>

          <div className="grid gap-4 md:grid-cols-3">
            <Card>
              <CardHeader className="pb-3">
                <CardTitle className="text-sm">Média 24h</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-indigo-600">150 mg/dL</p>
              </CardContent>
            </Card>
            <Card>
              <CardHeader className="pb-3">
                <CardTitle className="text-sm">Tempo no Alvo</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-green-600">60%</p>
              </CardContent>
            </Card>
            <Card>
              <CardHeader className="pb-3">
                <CardTitle className="text-sm">Eventos Hipoglicemia</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-red-600">0</p>
              </CardContent>
            </Card>
          </div>
        </TabsContent>

        <TabsContent value="insulin" className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle>Esquema de Insulinoterapia</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid gap-4">
                <div className="grid gap-2">
                  <Label>Tipo de Esquema</Label>
                  <p className="p-3 bg-gray-50 rounded-lg">
                    {patient.insulinType === 'basal-bolus' ? 'Basal-Bolus' :
                     patient.insulinType === 'correction-only' ? 'Apenas Correção' :
                     'Pré-misturada'}
                  </p>
                </div>

                {patient.basalDose && (
                  <div className="grid gap-2">
                    <Label>Dose Basal</Label>
                    {isEditing ? (
                      <Input
                        type="number"
                        value={editedPatient.basalDose || ''}
                        onChange={(e) => setEditedPatient({ ...editedPatient, basalDose: parseFloat(e.target.value) })}
                      />
                    ) : (
                      <p className="p-3 bg-gray-50 rounded-lg">{patient.basalDose} UI/dia</p>
                    )}
                  </div>
                )}

                <div className="grid gap-2">
                  <Label>Fator de Correção</Label>
                  {isEditing ? (
                    <Input
                      type="number"
                      value={editedPatient.correctionFactor || ''}
                      onChange={(e) => setEditedPatient({ ...editedPatient, correctionFactor: parseFloat(e.target.value) })}
                    />
                  ) : (
                    <p className="p-3 bg-gray-50 rounded-lg">{patient.correctionFactor || 50} mg/dL/UI</p>
                  )}
                </div>

                <div className="grid gap-2">
                  <Label>Meta Glicêmica</Label>
                  {isEditing ? (
                    <div className="flex gap-2">
                      <Input
                        type="number"
                        placeholder="Mínimo"
                        value={editedPatient.target.min}
                        onChange={(e) => setEditedPatient({
                          ...editedPatient,
                          target: { ...editedPatient.target, min: parseFloat(e.target.value) }
                        })}
                      />
                      <Input
                        type="number"
                        placeholder="Máximo"
                        value={editedPatient.target.max}
                        onChange={(e) => setEditedPatient({
                          ...editedPatient,
                          target: { ...editedPatient.target, max: parseFloat(e.target.value) }
                        })}
                      />
                    </div>
                  ) : (
                    <p className="p-3 bg-gray-50 rounded-lg">
                      {patient.target.min} - {patient.target.max} mg/dL
                    </p>
                  )}
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="clinical" className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle>Informações Clínicas</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid gap-2">
                <Label>Diagnóstico</Label>
                {isEditing ? (
                  <Input
                    value={editedPatient.diagnosis}
                    onChange={(e) => setEditedPatient({ ...editedPatient, diagnosis: e.target.value })}
                  />
                ) : (
                  <p className="p-3 bg-gray-50 rounded-lg">{patient.diagnosis}</p>
                )}
              </div>

              <div className="grid gap-2">
                <Label>Observações</Label>
                <div className="p-3 bg-gray-50 rounded-lg space-y-2">
                  <p className="text-sm">• Paciente não crítico em enfermaria</p>
                  <p className="text-sm">• Dieta hospitalar regular para diabéticos</p>
                  <p className="text-sm">• Monitorização capilar 4x/dia</p>
                  <p className="text-sm">• Sem sinais de infecção ativa</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
