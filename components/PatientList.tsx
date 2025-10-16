import { useState } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from './ui/card';
import { Button } from './ui/button';
import { Badge } from './ui/badge';
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from './ui/dialog';
import { Input } from './ui/input';
import { Label } from './ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from './ui/select';
import { Plus, User, Clock, TrendingUp, AlertCircle, Trash2 } from 'lucide-react';
import type { Patient } from '../App';

interface PatientListProps {
  patients: Patient[];
  selectedPatient: Patient | null;
  onSelectPatient: (patient: Patient) => void;
  onAddPatient: (patient: Patient) => void;
  onDeletePatient: (id: string) => void;
  onViewDetails: (patient: Patient) => void;
}

export function PatientList({ 
  patients, 
  selectedPatient, 
  onSelectPatient, 
  onAddPatient,
  onDeletePatient,
  onViewDetails 
}: PatientListProps) {
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [newPatient, setNewPatient] = useState({
    name: '',
    age: '',
    weight: '',
    diagnosis: '',
    insulinType: 'correction-only' as const,
  });

  const handleAddPatient = () => {
    const patient: Patient = {
      id: Date.now().toString(),
      name: newPatient.name,
      age: parseInt(newPatient.age),
      weight: parseFloat(newPatient.weight),
      admission: new Date().toISOString().split('T')[0],
      diagnosis: newPatient.diagnosis,
      insulinType: newPatient.insulinType,
      target: { min: 100, max: 140 },
    };
    
    onAddPatient(patient);
    setIsDialogOpen(false);
    setNewPatient({
      name: '',
      age: '',
      weight: '',
      diagnosis: '',
      insulinType: 'correction-only',
    });
  };

  const getGlycemiaStatus = (glycemia?: number) => {
    if (!glycemia) return null;
    if (glycemia < 70) return { label: 'Hipoglicemia', color: 'bg-red-500' };
    if (glycemia >= 70 && glycemia <= 140) return { label: 'Alvo', color: 'bg-green-500' };
    if (glycemia > 140 && glycemia <= 180) return { label: 'Elevada', color: 'bg-yellow-500' };
    return { label: 'Muito Alta', color: 'bg-red-500' };
  };

  const getInsulinTypeLabel = (type: string) => {
    switch (type) {
      case 'basal-bolus': return 'Basal-Bolus';
      case 'correction-only': return 'Correção';
      case 'premixed': return 'Pré-misturada';
      default: return type;
    }
  };

  return (
    <div className="space-y-4">
      <div className="flex justify-between items-center">
        <div>
          <h2>Pacientes Ativos</h2>
          <p className="text-gray-600 text-sm mt-1">
            Gerencie os pacientes não críticos em uso de insulinoterapia
          </p>
        </div>
        
        <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
          <DialogTrigger asChild>
            <Button className="flex items-center gap-2">
              <Plus className="w-4 h-4" />
              Novo Paciente
            </Button>
          </DialogTrigger>
          <DialogContent className="sm:max-w-[500px]">
            <DialogHeader>
              <DialogTitle>Adicionar Novo Paciente</DialogTitle>
              <DialogDescription>
                Insira os dados do paciente não crítico para iniciar o manejo da insulinoterapia.
              </DialogDescription>
            </DialogHeader>
            <div className="grid gap-4 py-4">
              <div className="grid gap-2">
                <Label htmlFor="name">Nome Completo</Label>
                <Input
                  id="name"
                  value={newPatient.name}
                  onChange={(e) => setNewPatient({ ...newPatient, name: e.target.value })}
                  placeholder="Ex: João da Silva"
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="grid gap-2">
                  <Label htmlFor="age">Idade</Label>
                  <Input
                    id="age"
                    type="number"
                    value={newPatient.age}
                    onChange={(e) => setNewPatient({ ...newPatient, age: e.target.value })}
                    placeholder="Anos"
                  />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="weight">Peso (kg)</Label>
                  <Input
                    id="weight"
                    type="number"
                    step="0.1"
                    value={newPatient.weight}
                    onChange={(e) => setNewPatient({ ...newPatient, weight: e.target.value })}
                    placeholder="kg"
                  />
                </div>
              </div>
              <div className="grid gap-2">
                <Label htmlFor="diagnosis">Diagnóstico</Label>
                <Input
                  id="diagnosis"
                  value={newPatient.diagnosis}
                  onChange={(e) => setNewPatient({ ...newPatient, diagnosis: e.target.value })}
                  placeholder="Ex: Diabetes Mellitus tipo 2"
                />
              </div>
              <div className="grid gap-2">
                <Label htmlFor="insulinType">Esquema de Insulina</Label>
                <Select
                  value={newPatient.insulinType}
                  onValueChange={(value: any) => setNewPatient({ ...newPatient, insulinType: value })}
                >
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="correction-only">Apenas Correção</SelectItem>
                    <SelectItem value="basal-bolus">Basal-Bolus</SelectItem>
                    <SelectItem value="premixed">Pré-misturada</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>
            <DialogFooter>
              <Button variant="outline" onClick={() => setIsDialogOpen(false)}>
                Cancelar
              </Button>
              <Button
                onClick={handleAddPatient}
                disabled={!newPatient.name || !newPatient.age || !newPatient.weight}
              >
                Adicionar Paciente
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </div>

      {patients.length === 0 ? (
        <Card>
          <CardContent className="flex flex-col items-center justify-center py-12">
            <User className="w-12 h-12 text-gray-400 mb-4" />
            <p className="text-gray-500 text-center">
              Nenhum paciente cadastrado.
              <br />
              Clique em "Novo Paciente" para começar.
            </p>
          </CardContent>
        </Card>
      ) : (
        <div className="grid gap-4 md:grid-cols-2">
          {patients.map((patient) => {
            const glycemiaStatus = getGlycemiaStatus(patient.lastGlycemia);
            const isSelected = selectedPatient?.id === patient.id;

            return (
              <Card
                key={patient.id}
                className={`cursor-pointer transition-all hover:shadow-lg ${
                  isSelected ? 'ring-2 ring-indigo-500' : ''
                }`}
                onClick={() => onSelectPatient(patient)}
              >
                <CardHeader>
                  <div className="flex justify-between items-start">
                    <div className="flex-1">
                      <CardTitle className="flex items-center gap-2">
                        {patient.name}
                        {glycemiaStatus && patient.lastGlycemia && patient.lastGlycemia > 180 && (
                          <AlertCircle className="w-4 h-4 text-red-500" />
                        )}
                      </CardTitle>
                      <CardDescription>
                        {patient.age} anos • {patient.weight} kg
                      </CardDescription>
                    </div>
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={(e) => {
                        e.stopPropagation();
                        if (confirm(`Tem certeza que deseja remover ${patient.name}?`)) {
                          onDeletePatient(patient.id);
                        }
                      }}
                    >
                      <Trash2 className="w-4 h-4 text-gray-400 hover:text-red-500" />
                    </Button>
                  </div>
                </CardHeader>
                <CardContent className="space-y-3">
                  <div>
                    <p className="text-sm text-gray-600">{patient.diagnosis}</p>
                  </div>
                  
                  <div className="flex items-center gap-2">
                    <Badge variant="outline">
                      {getInsulinTypeLabel(patient.insulinType)}
                    </Badge>
                    {patient.lastGlycemia && glycemiaStatus && (
                      <Badge className={`${glycemiaStatus.color} text-white`}>
                        {patient.lastGlycemia} mg/dL
                      </Badge>
                    )}
                  </div>

                  {patient.lastUpdate && (
                    <div className="flex items-center gap-2 text-sm text-gray-500">
                      <Clock className="w-4 h-4" />
                      Última atualização: {new Date(patient.lastUpdate).toLocaleString('pt-BR')}
                    </div>
                  )}

                  <div className="flex gap-2 pt-2">
                    <Button
                      variant="outline"
                      size="sm"
                      className="flex-1"
                      onClick={(e) => {
                        e.stopPropagation();
                        onViewDetails(patient);
                      }}
                    >
                      <TrendingUp className="w-4 h-4 mr-2" />
                      Ver Detalhes
                    </Button>
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </div>
      )}
    </div>
  );
}
